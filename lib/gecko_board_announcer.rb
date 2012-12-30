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
    action_frequencies = [["Action", "Daily %", "Weekly %", "Monthly %"]]
    network_sizes << network_size_headers
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
    network_sizes << ["1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)].map(&:to_s)
    network_sizes << ["6m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)].map(&:to_s)
    network_sizes << ["12m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)].map(&:to_s)
    network_sizes << ["18+m", fourth_bucket.count, average_size(fourth_bucket), average_penetration(fourth_bucket)].map(&:to_s)
    network_sizes << ["TOTAL", Community.all.count, average_size(Community.all), average_penetration(Community.all)].map(&:to_s)

    dashboard.table("Community Sizes", network_sizes)

    puts "Computing organic and paid growth..."

    # Break down growth by organic vs not organic
    growth_breakdown = [["", "%", "# of users"]]

    all_users = User.all
    launch_users = all_users.select do |u|
      u.created_at.to_date <= (u.community.launch_date + 3.months).to_date
    end
    organic_users = all_users - launch_users

    dashboard.pie("Growth Breakdown Pie", [
      { "Organic" => organic_users.count },
      { "Paid" => launch_users.count }
    ])

    # puts "Computing post distribution..."
    # # Post distribution
    # post_distribution = [["", "#", "Replies"]]
    # posts = Post.where(category: "help")
    # post_distribution << ["Questions", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    # posts = Post.where(category: "offers")
    # post_distribution << ["Marketplaces", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    # posts = Event.all
    # post_distribution << ["Events", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    # posts = Post.where(category: "neighborhood")
    # post_distribution << ["Town Discussions", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    # posts = Announcement.all
    # post_distribution << ["Announcements", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    # posts = Message.all
    # post_distribution << ["Private Messages", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)

    # dashboard.table("Post Breakdown", post_distribution)

    # puts "Computing growths..."
    # growths = growths.sort_by do |v|
      # v[1]
    # end.append(growth_headers).reverse
    # dashboard.table("Growth by Community", growths)
    # dashboard.pie("Population by Community", populations)

    puts "Computing penetrations..."
    dashboard.number("Overall Penetration", average_penetration(Community.all).round(2))

    puts "Computing growth rates..."
    growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
    dashboard.number("Overall Weekly Growth Rate", (100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f).round(2))

    # puts "Computing reply percentages..."
    # all_posts = Post.all + Announcement.all + GroupPost.all + Event.all

    # reply_pctg = 100 * (all_posts.select { |r| r.replies.any? }.count.to_f / all_posts.count.to_f).round(2)
    # dashboard.number("Reply Percent", reply_pctg) # TODO: Fix this number to include privatemessages

    # puts "Computing posts per network..."
    # items = Post.all #all_posts.uniq
    # total = items.count
    # posts_per_network = total / items.compact.map { |c| c.try(:community) }.uniq.compact.count
    # dashboard.number("Posts per Network", posts_per_network)

    puts "Doing AUs..."
    wau_start = 1.week.ago - 2.days
    # mau_start = 1.month.ago - 2.days
    # FIXME make this one month
    mau_start = wau_start
    dau_start = 1.day.ago - 4.days
    au_end = wau_start + 1.week - 2.days


    # This has to happen last, since it messes with ActiveRecord
    puts "Starting MAU calculation"
    $OriginalConnection = ActiveRecord::Base.connection
    require 'kmdb'
    t1 = Time.now

    puts "Connected to MySQL"
    wau = KMDB::Event.before(au_end).after(wau_start).named('platform activity').map(&:user_id).uniq.count
    dashboard.number("Weekly Active Users", wau.to_s)
    puts "WAU: #{wau}"
    puts "WAU took #{Time.now - t1} seconds"
    mau = KMDB::Event.before(au_end).after(mau_start).named('platform activity').map(&:user_id).uniq.count
    puts "MAU: #{mau}"
    dashboard.number("Monthly Active Users", mau.to_s)
    dau = KMDB::Event.before(au_end).after(dau_start).named('platform activity').map(&:user_id).uniq.count
    puts "DAU: #{dau}"
    dashboard.number("Daily Active Users", dau.to_s)

    puts "Took #{Time.now - t1} seconds"

    puts "Doing as percentages..."

    # Make them percentages of the user base
    wau = (wau.to_f / User.count).round(2)
    dau = (dau.to_f / User.count).round(2)
    mau = (mau.to_f / User.count).round(2)

    dashboard.number("WAU", wau.to_s)
    dashboard.number("MAU", mau.to_s)
    dashboard.number("Daily Active", dau.to_s)

    puts "Doing daily frequencies"

    # Daily frequencies

    # action_frequencies << ["Open Daily Bulletin",
                           # (KMDB::Event.before(au_end).after(dau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (KMDB::Event.before(au_end).after(wau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (KMDB::Event.before(au_end).after(mau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    action_frequencies << ["Open Daily Bulletin", "N/A", "N/A", "N/A"]
    action_frequencies << ["Open Single Post", "N/A", "N/A", "N/A"]
    action_frequencies << ["Visit Site",
                           (KMDB::Event.before(au_end).after(dau_start).named('visited site').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(wau_start).named('visited site').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(mau_start).named('visited site').map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    # TODO: Check this one's name
    action_frequencies << ["Reply",
                           (KMDB::Event.before(au_end).after(dau_start).named('posted  reply').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(wau_start).named('posted  reply').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(mau_start).named('posted  reply').map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    action_frequencies << ["PM",
                           (KMDB::Event.before(au_end).after(dau_start).named('posted  message').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(wau_start).named('posted  message').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(mau_start).named('posted  message').map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    action_frequencies << ["Post",
                           (KMDB::Event.before(au_end).after(dau_start).named('posted  post').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(wau_start).named('posted  post').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(mau_start).named('posted  post').map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    action_frequencies << ["Add Data",
                           (KMDB::Event.before(au_end).after(dau_start).named('posted content').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(wau_start).named('posted content').map(&:user_id).uniq.count.to_f / User.count).round(2),
                           (KMDB::Event.before(au_end).after(mau_start).named('posted content').map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    dashboard.table("Action Frequencies", action_frequencies)

    puts "ACTION FREQUENCIES"
    puts action_frequencies.inspect

    ActiveRecord::Base.establish_connection

    puts "Done"

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
