class GeckoBoardAnnouncer
  @queue = :statistics

  EXCLUDED_COMMUNITIES = %w[
    Raleigh
    Clarkston
    GroveHall
    Akron
    hinckley
    missionhill
    GraduateCommons
    HarvardNeighbors
  ]

  def self.average_size(communities)
    (communities.map { |c| c.users.count }.inject{ |sum, el| sum + el }.to_f / communities.size).round(2)
  end

  def self.average_penetration(communities)
    penetrations = communities.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.penetration_percentage(false) }.reject { |v| v < 0 }
    (100 * (penetrations.inject{ |sum, el| sum + el }.to_f / communities.size)).round(2)
  end

  def self.perform
    tz = "Eastern Time (US & Canada)"
    dashboard = Leftronic.new(ENV['LEFTRONIC_API_KEY'] || '')
    dashboard.text("Statistics Information", "Update Started", "Began updating at #{DateTime.now.in_time_zone(tz).to_s}")
    dashboard.number("Users on Network", User.count)
    growths = []
    populations = []
    growth_headers = ["Community", "Users", "Wkly Growth", "Penetration", "Posts/Day"]
    network_sizes = []
    network_size_headers = ["Age", "#", "Avg Size", "Avg Pen"]
    action_frequencies = [["Action", "Daily %", "Weekly %", "Monthly %", "Weekly #"]]
    network_sizes << network_size_headers
    unless ENV['ONLY_AU'] == 'true'
      Community.find_each do |community|
        next if EXCLUDED_COMMUNITIES.include? community.slug
        growth = (community.growth_percentage.round(2))
        growth = "DNE" if growth.infinite?
        penetration = community.penetration_percentage.round(2)
        begin
          posts_per_day = ((community.posts.count + community.announcements.count + community.events.count + community.group_posts.count) / (Date.today - community.launch_date.to_date)).to_d.round(2).to_s
        rescue
          posts_per_day = ""
        end
        growths << [community.name, community.users.count, "#{growth}%", "#{penetration.to_s.gsub("-1.0", "0")}%", posts_per_day]
        populations << {
          community.name => community.users.count
        }
      end

      # Do the network sizes
      puts "Computing network sizes..."
      first_bucket = Community.all.select do |c|
        c.launch_date >= Date.today - 1.month
      end
      second_bucket = Community.all.select do |c|
        c.launch_date >= Date.today - 6.months and c.launch_date < Date.today - 1.month
      end
      third_bucket = Community.all.select do |c|
        c.launch_date >= Date.today - 12.months and c.launch_date < Date.today - 6.month
      end
      fourth_bucket = Community.all.select do |c|
        c.launch_date >= Date.today - 18.months and c.launch_date < Date.today - 12.month
      end
      fifth_bucket = Community.all.select do |c|
        c.launch_date < Date.today - 18.month
      end
      network_sizes << ["1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)].map(&:to_s)
      network_sizes << ["6m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)].map(&:to_s)
      network_sizes << ["12m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)].map(&:to_s)
      network_sizes << ["18m", fourth_bucket.count, average_size(fourth_bucket), average_penetration(fourth_bucket)].map(&:to_s)
      network_sizes << ["24m+", fifth_bucket.count, average_size(fifth_bucket), average_penetration(fifth_bucket)].map(&:to_s)
      network_sizes << ["TOTAL", "", "", ""].map(&:to_s)

      launch_dates = Community.all.map(&:launch_date).map(&:to_time)
      average_launch_date = Time.at(launch_dates.inject{ |sum, el| sum + el.to_i }.to_f / launch_dates.size.to_f).to_datetime
      average_age = ((Date.today - average_launch_date).to_f/30).round(1)

      network_sizes << ["#{average_age}m", Community.all.count, average_size(Community.all), average_penetration(Community.all)].map(&:to_s)

      dashboard.table("Community Sizes", network_sizes)

      puts "Computing organic and paid growth..."
      all_users = User.all
      all_communities = Community.all

      # Break down growth by organic vs not organic
      growth_breakdown = [["", "%", "#"]]

      # 1) Find the number of users in "paid" communities that were created today
      # 2) Find the number of users in "organic" communities that were created today

      paid_communities = all_communities.select do |c|
        Date.today <= (c.launch_date.to_date + 3.months).to_date
      end
      organic_communities = all_communities - paid_communities
      new_users_today = User.between((DateTime.now - 1.week), DateTime.now)
      user_count_yesterday = User.count - new_users_today.count

      paid_users = new_users_today.where("community_id IN (#{paid_communities.map(&:id).join(",")})")
      organic_users = new_users_today - paid_users

      growth_breakdown << ["Paid", "#{(100*paid_users.count.to_f / user_count_yesterday).round(2)}%", paid_users.count.to_s]
      growth_breakdown << ["Organic", "#{(100*organic_users.count.to_f / user_count_yesterday).round(2)}%", organic_users.count.to_s]

      dashboard.table("Growth Breakdown", growth_breakdown)

      unless ENV['SKIP_POST_DISTRIBUTION'] == 'true'
        puts "Computing post distribution..."
        # Post distribution
        post_distribution = [["", "#", "Replies", "Reply %"]]
        posts_map = {
          "Questions" => Post.where(category: "help"),
          "Marketplaces" => Post.where(category: "offers"),
          "Events" => Event.scoped,
          "Town Discussions" => Post.where(category: "neighborhood"),
          "Announcements" => Announcement.scoped,
          "Private Messages" => Message.scoped
        }
        posts_map.each do |title, posts|
          posts_with_replies = posts.select { |p| p.replies.any? }
          post_distribution << [title, posts.count, posts.map(&:replies).flatten.count, (100*posts_with_replies.count / posts.count).round(2)].map(&:to_s)
        end
        puts "POST BREAKDOWN"
        puts post_distribution.inspect
        dashboard.table("Post Breakdown", post_distribution)
      end

      puts "Computing penetrations..."
      dashboard.number("Overall Penetration", average_penetration(Community.all).round(2))

      puts "Computing growth rates..."
      growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
      dashboard.number("Overall Weekly Growth Rate", (100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f).round(2))
      dashboard.number("Overall Weekly Growth", User.between(DateTime.now - 1.week, DateTime.now).count)

      unless ENV['SKIP_REPLY'] == 'true'
        puts "Computing reply percentages..."
        all_posts = Post.all + Announcement.all + GroupPost.all + Event.all

        reply_pctg = 100 * (all_posts.select { |r| r.replies.any? }.count.to_f / all_posts.count.to_f).round(2)
        dashboard.number("Reply Percent", reply_pctg.to_s) # TODO: Fix this number to include privatemessages
      end

      puts "Computing posts per network..."
      items = Post.all #all_posts.uniq
      total = items.count
      posts_per_network = total / Community.count
      dashboard.number("Posts per Network", posts_per_network)
    end

    puts "Doing AUs..."
    au_end = 2.days.ago
    wau_start = au_end - 1.week
    # FIXME make this one month
    # mau_start = au_end - 1.month
    mau_start = wau_start
    dau_start = au_end - 1.day

    puts "Considering the week to start on #{wau_start.to_date} and end on #{au_end.to_date}"

    # This has to happen last, since it messes with ActiveRecord
    puts "Starting MAU calculation"
    $OriginalConnection = ActiveRecord::Base.connection
    require 'kmdb'
    t1 = Time.now

    puts "Connected to MySQL"
    wau = KMDB::Event.before(au_end).after(wau_start).named('platform activity').map(&:user_id).uniq.count
    dashboard.number("Weekly Active Users", wau.to_s)
    puts "WAU: #{wau}"
    mau = KMDB::Event.before(au_end).after(mau_start).named('platform activity').map(&:user_id).uniq.count
    puts "MAU: #{mau}"
    dashboard.number("Monthly Active Users", mau.to_s)
    puts "MAU took #{Time.now - t1} seconds"
    dau = KMDB::Event.before(au_end).after(dau_start).named('platform activity').map(&:user_id).uniq.count
    puts "DAU: #{dau}"
    dashboard.number("Daily Active Users", dau.to_s)

    puts "Doing as percentages..."

    # Make them percentages of the user base
    wau = (100*wau.to_f / User.count).round(2)
    dau = (100*dau.to_f / User.count).round(2)
    mau = (100*mau.to_f / User.count).round(2)

    dashboard.number("WAU", wau.to_s)
    dashboard.number("MAU", mau.to_s)
    dashboard.number("Daily Active", dau.to_s)

    puts "Doing daily frequencies"

    # Daily frequencies

    # action_frequencies << ["Open Daily Bulletin",
                           # (100*KMDB::Event.before(au_end).after(dau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (100*KMDB::Event.before(au_end).after(wau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (100*KMDB::Event.before(au_end).after(mau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    event_map = {
      "Open Daily Bulletin" => "opened daily_bulletin email",
      "Open Single Post" => "opened single_post email",
      "Visit Site" => "visited site",
      "Reply" => "posted  reply",
      "PM" => "posted  message",
      "Post" => "posted  post",
      "Add Data" => "posted content"
    }
    event_map.each do |title, event|
      action_frequencies << [title.to_s,
                             (100*KMDB::Event.before(au_end).after(dau_start).named(event).map(&:user_id).uniq.count.to_f / User.count).round(2).to_s,
                             (100*KMDB::Event.before(au_end).after(wau_start).named(event).map(&:user_id).uniq.count.to_f / User.count).round(2).to_s,
                             (100*KMDB::Event.before(au_end).after(mau_start).named(event).map(&:user_id).uniq.count.to_f / User.count).round(2).to_s,
                              KMDB::Event.before(au_end).after(wau_start).named(event).map(&:user_id).uniq.count.to_s]
    end
    dashboard.table("Action Frequencies", action_frequencies)

    puts "Doing repeated engagement"

    repeated_engagement = [["", "2x Daily", "2x Weekly", "2x Monthly"]]
    event_map = {
      "Visit Site" => "visited site",
      "Add Data" => "posted content"
    }
    event_map.each do |title, event|
      daily_repetitions = KMDB::Event.before(au_end).after(dau_start).named(event).select { |e|
        KMDB::Event.named(event).before(au_end).after(DateTime.parse(e.t_before_type_cast)).where(user_id: e.user_id).any?
      }.map(&:user_id).uniq.count.to_f
      weekly_repetitions = KMDB::Event.before(au_end).after(wau_start).named(event).select { |e|
        KMDB::Event.named(event).before(au_end).after(DateTime.parse(e.t_before_type_cast)).where(user_id: e.user_id).any?
      }.map(&:user_id).uniq.count.to_f
      monthly_repetitions = KMDB::Event.before(au_end).after(mau_start).named(event).select { |e|
        KMDB::Event.named(event).before(au_end).after(DateTime.parse(e.t_before_type_cast)).where(user_id: e.user_id).any?
      }.map(&:user_id).uniq.count.to_f
      repeated_engagement << [title.to_s,
        (100*daily_repetitions / User.count).round(2).to_s,
        (100*weekly_repetitions / User.count).round(2).to_s,
        (100*monthly_repetitions / User.count).round(2).to_s
      ]
    end

    dashboard.table("Repeated Engagement", repeated_engagement)

    ActiveRecord::Base.establish_connection

    puts "Done"

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
