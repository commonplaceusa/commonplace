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
    Avon
    Springfield
  ]

  WATCHED_COMMUNITIES = %w[
    FallsChurch
    Harrisonburg
    Vienna
    Marquette
    Warwick
    OwossoCorunna
    Chelmsford
    Belmont
    Watertown
    Sudbury
    Westwood
    Hudson
  ]

  def self.average_size(communities)
    (communities.map { |c| c.users.count }.inject{ |sum, el| sum + el }.to_f / communities.size).round(2)
  end

  def self.average_penetration(communities)
    penetrations = communities.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.penetration_percentage(false) }.reject { |v| v < 0 }
    (100 * (penetrations.inject{ |sum, el| sum + el }.to_f / communities.size)).round(2)
  end

  def self.full_run
    run(false)
  end

  def self.perform(quick = true)
    run(quick)
  end

  def self.run(quick = true)
    if quick == true
      ENV['SKIP_POST_DISTRIBUTION'] = 'true'
      ENV['SKIP_REPLY'] = 'true'
      ENV['SKIP_REPEATED_ENGAGEMENT'] = 'true'
      ENV['SKIP_MEMOIZED_DATA'] = 'true'
    end
    mailgun = RestClient::Resource.new 'https://api:key-1os8gyo-wfo1ia85yzrih0ib8xq7n050@api.mailgun.net/v2/ourcommonplace.com'
    tz = "Eastern Time (US & Canada)"
    dashboard = MemoizingDashboard.new(ENV['LEFTRONIC_API_KEY'] || '')
    dashboard.text("Statistics Information", "Update Started", "Began updating at #{DateTime.now.in_time_zone(tz).to_s}")
    dashboard.number("Users on Network", User.count)
    growths = []
    populations = []
    growth_headers = ["Community", "Users", "Weekly Growth", "Penetration", "Posts/Day", "Daily Bulletins Opened/Wk", "Single Posts Opened/Wk"]
    network_sizes = []
    network_size_headers = ["Age", "#", "Avg Size", "Avg Pen"]
    action_frequencies = [["Action", "Daily %", "Weekly %", "Monthly %", "Weekly #"]]
    network_sizes << network_size_headers

    unless ENV['SKIP_MEMOIZED_DATA']
      # Handle memoized data
      post_count_str = Resque.redis.get("statistics:post_counts")
      unless post_count_str.present?
        post_count_str =  ",#{WATCHED_COMMUNITIES.join(",")}"
      end
      # Check the first line for all communities...
      split_post_count_lines = post_count_str.split("\n")
      if post_count_str.split("\n").shift.split(",").count != WATCHED_COMMUNITIES.count
        # HOLD INVARIANT: Communities will not be deleted from WATCHED_COMMUNITIES, nor reordered
        # New communities will be appended to the end of the list
        # This allows us to make the following optimization:
        first_line = true
        missing_communities = WATCHED_COMMUNITIES.map(&:to_s) - split_post_count_lines.first.split(",")
        split_post_count_lines.each do |line|
          if first_line
            line << ","
            line << missing_communities.join(",")
          else
            missing_communities.times do
              line << ",0"
            end
          end
          first_line = false
        end
      end

      new_post_counts = []
      WATCHED_COMMUNITIES.each do |slug|
        puts slug
        new_post_counts << Community.find_by_slug(slug).posts.today.count.to_s
      end
      new_post_line = "#{Date.today.to_s(:mdy)},#{new_post_counts.join(",")}"
      post_count_str << "\n"
      post_count_str << new_post_line

      # post_headers = post_counts.shift.map { |i| i.to_s }
      # post_string_data = post_counts.map { |row| row.map { |cell| cell.to_s } }
      # post_count_assoc = post_string_data.map { |row| Hash[*post_headers.zip(row).flatten] }
      Resque.redis.set("statistics:post_counts", post_count_str)
    end

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
        growths << [community.slug, community.users.count, "#{growth}%", "#{penetration.to_s.gsub("-1.0", "0")}%", posts_per_day]
        populations << {
          community.name => community.users.count
        }
      end
      growths = growths.sort do |x, y|
        x[1].to_i <=> y[1].to_i
      end
      growths << growth_headers
      growths.reverse!


      # Do the network sizes
      puts "Computing network sizes..."
      relevant_communities = Community.all.reject do |c|
        EXCLUDED_COMMUNITIES.include? c.slug
      end
      first_bucket = relevant_communities.select do |c|
        c.launch_date >= Date.today - 1.month
      end
      second_bucket = relevant_communities.select do |c|
        c.launch_date >= Date.today - 6.months and c.launch_date < Date.today - 1.month
      end
      third_bucket = relevant_communities.select do |c|
        c.launch_date >= Date.today - 12.months and c.launch_date < Date.today - 6.months
      end
      fourth_bucket = relevant_communities.select do |c|
        c.launch_date >= Date.today - 18.months and c.launch_date < Date.today - 12.months
      end
      fifth_bucket = relevant_communities.select do |c|
        c.launch_date < Date.today - 18.months
      end
      network_sizes << ["<1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)].map(&:to_s)
      network_sizes << ["1-6m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)].map(&:to_s)
      network_sizes << ["6-12m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)].map(&:to_s)
      network_sizes << ["12-18m", fourth_bucket.count, average_size(fourth_bucket), average_penetration(fourth_bucket)].map(&:to_s)
      network_sizes << ["18m+", fifth_bucket.count, average_size(fifth_bucket), average_penetration(fifth_bucket)].map(&:to_s)
      network_sizes << ["TOTAL", "", "", ""].map(&:to_s)

      launch_dates = relevant_communities.map(&:launch_date).map(&:to_time)
      average_launch_date = Time.at(launch_dates.inject{ |sum, el| sum + el.to_i }.to_f / launch_dates.size.to_f).to_datetime
      average_age = ((Date.today - average_launch_date).to_f/30).round(1)

      network_sizes << ["#{average_age}m", relevant_communities.count, average_size(relevant_communities), average_penetration(relevant_communities)].map(&:to_s)

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
          post_distribution << [title, posts.count, posts.map(&:replies).flatten.count, (100*posts_with_replies.count.to_f / posts.count.to_f).round(2)].map(&:to_s)
        end
        puts "POST BREAKDOWN"
        puts post_distribution.inspect
        dashboard.table("Post Breakdown", post_distribution)
      end

      puts "Computing penetrations..."
      dashboard.number("Overall Penetration", average_penetration(Community.all).round(2))

      puts "Computing growth rates..."
      growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
      # dashboard.number("Overall Weekly Growth Rate", (100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f).round(2))
      # dashboard.number("Overall Weekly Growth", User.between(DateTime.now - 1.week, DateTime.now).count)
      dashboard.number("Overall Weekly Growth Rate", (100*((User.between(DateTime.now - 1.week, DateTime.now).count.to_f)/((User.up_to(DateTime.now - 1.week).count + User.up_to(DateTime.now).count)/2))).round(2))
      dashboard.number("Overall Weekly Growth", User.between(DateTime.now - 1.week, DateTime.now).count)

      unless ENV['SKIP_REPLY'] == 'true'
        puts "Computing reply percentages..."
        all_posts = Post.all + Announcement.all + GroupPost.all + Event.all

        reply_pctg = 100 * (all_posts.select { |r| r.replies.any? }.count.to_f / all_posts.count.to_f).round(2)
        dashboard.number("Reply Percent", reply_pctg.to_s) # TODO: Fix this number to include privatemessages
      end

      puts "Computing posts per network..."
      items = Post.between(DateTime.now - 1.day, DateTime.now) #all_posts.uniq
      total = items.count
      posts_per_network = (total.to_f / Community.count).round(2)
      dashboard.number("Posts per Network", posts_per_network)
    end

    puts "Doing AUs..."
    au_end = 1.days.ago
    unless ENV['DO_NOT_SHIFT_KM_DAY']
      au_end = 2.days.ago
    end
    wau_start = au_end - 1.week
    if ENV['MONTHLY_IS_WEEKLY'] == 'true'
      mau_start = wau_start
    else
      mau_start = au_end - 1.month
    end
    dau_start = au_end - 1.day

    puts "Considering the week to start on #{wau_start.to_date} and end on #{au_end.to_date}"

    # This has to happen last, since it messes with ActiveRecord
    puts "Starting MAU calculation"
    $UserCount = User.count # Save so that when we switch models, there isn't a calculation error
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
    dau_users = KMDB::Event.before(au_end).after(dau_start).named('platform activity').map(&:user_id).uniq
    dau = dau_users.count
    puts "DAU: #{dau}"
    dashboard.number("Daily Active Users", dau.to_s)

    puts "Doing as percentages..."

    # Make them percentages of the user base
    wau = (100*wau.to_f / $UserCount).round(2)
    dau = (100*dau.to_f / $UserCount).round(2)
    mau = (100*mau.to_f / $UserCount).round(2)

    dashboard.number("WAU", wau.to_s)
    dashboard.number("MAU", mau.to_s)
    dashboard.number("Daily Active", dau.to_s)



    # Daily frequencies

    # action_frequencies << ["Open Daily Bulletin",
                           # (100*KMDB::Event.before(au_end).after(dau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (100*KMDB::Event.before(au_end).after(wau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2),
                           # (100*KMDB::Event.before(au_end).after(mau_start).named().map(&:user_id).uniq.count.to_f / User.count).round(2)].map(&:to_s)
    event_map = {
      "Visit Site" => "visited site",
      "Reply" => "posted  reply",
      "PM" => "posted  message",
      "Post" => "posted  post",
      "Add Data" => "posted content",
      "Concatenation" => "platform activity"
    }
    puts "Pulling and coallating data from Mailgun..."
    mailgun_campaign_list = JSON.parse(mailgun['campaigns'].get)['items'].map { |i| i['name'] }
    mailgun_daily_bulletin_campaigns = mailgun_campaign_list.select { |name| name.include? "_daily" }
    mailgun_single_post_campaigns = mailgun_campaign_list.select { |name| name.include? "_post" }
    # Coallate
    daily_bulletin_opens = {
      daily: {
        total: 0
      },
      weekly: {
        total: 0
      },
      monthly: {
        total: 0
      }
    }
    single_post_opens = {
      daily: {
        total: 0
      },
      weekly: {
        total: 0
      },
      monthly: {
        total: 0
      }
    }
    mailgun_daily_bulletin_campaigns.each do |campaign_name|
      # Access campaign open stats
      # Coallate into daily_bulletin_opens
      community_slug = campaign_name.split("_").first.to_sym
      daily_bulletin_opens[:daily][community_slug] = 0
      daily_bulletin_opens[:weekly][community_slug] = 0
      daily_bulletin_opens[:monthly][community_slug] = 0
      open_stats = JSON.parse(mailgun["campaigns/#{campaign_name}/opens?groupby=day&limit=30"].get)
      open_stats.each do |daily_dump|
        opened_at = DateTime.parse(daily_dump['day'])
        unique_recipients = daily_dump['unique']['recipient'].to_i
        if opened_at > 1.day.ago
          daily_bulletin_opens[:daily][:total] += unique_recipients
          daily_bulletin_opens[:weekly][:total] += unique_recipients
          daily_bulletin_opens[:monthly][:total] += unique_recipients
          daily_bulletin_opens[:daily][community_slug] += unique_recipients
          daily_bulletin_opens[:weekly][community_slug] += unique_recipients
          daily_bulletin_opens[:monthly][community_slug] += unique_recipients
        elsif opened_at > 7.days.ago
          daily_bulletin_opens[:weekly][:total] += unique_recipients
          daily_bulletin_opens[:monthly][:total] += unique_recipients
          daily_bulletin_opens[:weekly][community_slug] += unique_recipients
          daily_bulletin_opens[:monthly][community_slug] += unique_recipients
        elsif opened_at > 30.days.ago
          daily_bulletin_opens[:monthly][:total] += unique_recipients
          daily_bulletin_opens[:monthly][community_slug] += unique_recipients
        end
      end
    end
    mailgun_single_post_campaigns.each do |campaign_name|
      open_stats = JSON.parse(mailgun["campaigns/#{campaign_name}/opens?groupby=day&limit=30"].get)
      community_slug = campaign_name.split("_").first.to_sym
      single_post_opens[:daily][community_slug] = 0
      single_post_opens[:weekly][community_slug] = 0
      single_post_opens[:monthly][community_slug] = 0
      open_stats.each do |daily_dump|
        opened_at = DateTime.parse(daily_dump['day'])
        unique_recipients = daily_dump['unique']['recipient'].to_i
        if opened_at > 1.day.ago
          single_post_opens[:daily][:total] += unique_recipients
          single_post_opens[:weekly][:total] += unique_recipients
          single_post_opens[:monthly][:total] += unique_recipients
          single_post_opens[:daily][community_slug] += unique_recipients
          single_post_opens[:weekly][community_slug] += unique_recipients
          single_post_opens[:monthly][community_slug] += unique_recipients
        elsif opened_at > 7.days.ago
          single_post_opens[:weekly][:total] += unique_recipients
          single_post_opens[:monthly][:total] += unique_recipients
          single_post_opens[:weekly][community_slug] += unique_recipients
          single_post_opens[:monthly][community_slug] += unique_recipients
        elsif opened_at > 30.days.ago
          single_post_opens[:monthly][:total] += unique_recipients
          single_post_opens[:monthly][community_slug] += unique_recipients
        end
      end
    end
    action_frequencies << ["Open Daily Bulletin",
                           (100 * daily_bulletin_opens[:daily][:total].to_f / $UserCount).round(2),
                           (100 * daily_bulletin_opens[:weekly][:total].to_f / $UserCount).round(2),
                           (100 * daily_bulletin_opens[:monthly][:total].to_f / $UserCount).round(2),
                           daily_bulletin_opens[:weekly][:total]
    ]
    action_frequencies << ["Open Single Post",
                           (100 * single_post_opens[:daily][:total].to_f / $UserCount).round(2),
                           (100 * single_post_opens[:weekly][:total].to_f / $UserCount).round(2),
                           (100 * single_post_opens[:monthly][:total].to_f / $UserCount).round(2),
                           single_post_opens[:weekly][:total]
    ]
    # Break it down by community
    (1..(growths.count-1)).each do |i|
      community_name = growths[i][0].to_sym
      if daily_bulletin_opens[:weekly][community_name].nil?
        growths[i] << "N/A"
      else
        growths[i] << daily_bulletin_opens[:weekly][community_name].to_s
      end

      if single_post_opens[:weekly][community_name].nil?
        growths[i] << "N/A"
      else
        growths[i] << single_post_opens[:weekly][community_name].to_s
      end
    end
    dashboard.table("Growth by Community", growths)

    puts "Doing daily frequencies"
    event_map.each do |title, event|
      action_frequencies << [title.to_s,
                             (100*KMDB::Event.before(au_end).after(dau_start).named(event).map(&:user_id).uniq.count.to_f / $UserCount).round(2).to_s,
                             (100*KMDB::Event.before(au_end).after(wau_start).named(event).map(&:user_id).uniq.count.to_f / $UserCount).round(2).to_s,
                             (100*KMDB::Event.before(au_end).after(mau_start).named(event).map(&:user_id).uniq.count.to_f / $UserCount).round(2).to_s,
                              KMDB::Event.before(au_end).after(wau_start).named(event).map(&:user_id).uniq.count.to_s]
    end
    dashboard.table("Action Frequencies", action_frequencies)


    unless ENV['SKIP_REPEATED_ENGAGEMENT']
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
          (100*daily_repetitions / $UserCount).round(2).to_s,
          (100*weekly_repetitions / $UserCount).round(2).to_s,
          (100*monthly_repetitions / $UserCount).round(2).to_s
        ]
      end

      dashboard.table("Repeated Engagement", repeated_engagement)
    end

    ActiveRecord::Base.establish_connection

    # Segment dau_users by community
    # grouped_dau = dau_users.group_by do |uid|
      # begin
        # User.find(uid).community.name
      # rescue
        # 0
      # end
    # end

    puts "Done"

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
