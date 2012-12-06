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
    (communities.map(&:penetration_percentage).inject{ |sum, el| sum + el }.to_f / communities.size).round(2)
  end

  def self.perform
    tz = "Eastern Time (US & Canada)"
    dashboard = Leftronic.new(ENV['LEFTRONIC_API_KEY'] || '')
    dashboard.text("Statistics Information", "Update Started", "Began updating at #{DateTime.now.in_time_zone(tz).to_s}")
    dashboard.number("Users on Network", User.count)
    growths = []
    populations = []
    growth_headers = ["Community", "Users", "Wkly Growth", "Penetration", "Posts Per Day"]
    network_sizes = []
    network_size_headers = ["Age", "# of Networks", "Avg Size", "Avg Penetration"]
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

    first_bucket = Community.all.select do |c|
      c.launch_date >= Date.today - 1.month
    end
    second_bucket = Community.all.select do |c|
      c.launch_date >= Date.today - 4.months and c.launch_date < Date.today - 1.month
    end
    third_bucket = Community.all.select do |c|
      c.launch_date >= Date.today - 11.months and c.launch_date < Date.today - 4.month
    end
    network_sizes << ["1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)]
    network_sizes << ["4m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)]
    network_sizes << ["11m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)]
    network_sizes << ["TOTAL", Community.all.count, average_size(Community.all), average_penetration(Community.all)]

    dashboard.table("Community Sizes", network_sizes)

    # Break down growth by organic vs not organic
    growth_breakdown = [["", "%", "# of users"]]
    # Organic growth
    growth_breakdown << ["Organic Growth", "", ""]
    # Launch growth
    growth_breakdown << ["Launch Growth", "", ""]

    dashboard.table("Growth Breakdown", growth_breakdown)

    # Post distribution
    post_distribution = [["", "#", "Reply #", "PM #"]]
    post_distribution << ["Questions"]
    post_distribution << ["Marketplace"]
    post_distribution << ["Events"]
    post_distribution << ["Town Discussions"]
    post_distribution << ["Announcements"]
    post_distribution << ["Private Messages"]

    dashboard.table("Post Breakdown", post_distribution)

    growths = growths.sort_by do |v|
      v[1]
    end.append(growth_headers).reverse
    dashboard.table("Growth by Community", growths)
    dashboard.pie("Population by Community", populations)

    penetrations = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.penetration_percentage(false) }.reject { |v| v < 0 }
    dashboard.number("Overall Penetration", 100 * penetrations.inject{ |sum, el| sum + el }.to_f / penetrations.size)

    growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
    dashboard.number("Overall Weekly Growth Rate", 100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f)

    dashboard.number("Daily Bulletins Sent Today", DailyStatistic.value("daily_bulletins_sent") || 0)
    dashboard.number("Daily Bulletins Opened Today", DailyStatistic.value("daily_bulletins_opened") || 0)
    # dashboard.number("Daily Bulletin Open Rate Today", DailyStatistic.value("daily_bulletins_opened").to_f / DailyStatistic.value("daily_bulletins_sent").to_f)
    dashboard.number("Single Post Emails Sent Today", DailyStatistic.value("single_posts_sent") || 0)
    dashboard.number("Single Post Emails Opened Today", DailyStatistic.value("single_posts_opened") || 0)
    # dashboard.number("Single Post Email Open Rate Today", DailyStatistic.value("single_posts_opened").to_f / DailyStatistic.value("single_posts_sent").to_f)
    # emails = []
    # Resque.redis.keys("statistics:daily:*_sent").each do |key|
      # email_tag = key.gsub("statistics:daily:", "").gsub("_sent", "")
      # emails << {
        # email_tag => Resque.redis.get(key).to_i
      # }
    # end
    # dashboard.pie("Todays Emails by Tag", emails)
    #
    postings = {}
    [Post, Announcement, GroupPost, Event].each do |klass|
      key = (klass.first.respond_to? :category) ? Proc.new { |obj| obj.category } : Proc.new { |obj| obj.class.name }
      klass.today.each do |item|
        if postings.include? key.call(item)
          postings[key.call(item)] += 1
        else
          postings[key.call(item)] = 1
        end
      end
    end
    posts = []
    postings.each do |k,c|
      posts << {
        k => c
      }
    end
    dashboard.pie("Todays Posts by Category", posts)

    all_posts = Post.all + Announcement.all + GroupPost.all + Event.all

    reply_pctg = 100 * (all_posts.select { |r| r.replies.any? }.count / all_posts.count)
    dashboard.number("Reply Percent", reply_pctg) # TODO: Fix this number to include privatemessages

    items = all_posts
    total = items.count
    posts_per_network = total / items.map(&:community).uniq.count
    dashboard.number("Posts per Network", posts_per_network)

    # dashboard.number("Active Workers", HerokuResque::WorkerScaler.count("worker"))

    # dashboard.number("E-Mails in Queue", Resque.size("notifications"))

    # dashboard.text("Statistics Information", "Update Finished", "Finished updating at #{DateTime.now.in_time_zone(tz).to_s}")

    wau_start = 1.week.ago - 2.days
    mau_start = 1.month.ago - 2.days
    dau_start = 1.day.ago - 2.days
    au_end = wau_start + 1.week - 2.days

    # raise "Starting MAU calculation"

    # This has to happen last, since it messes with ActiveRecord
    $OriginalConnection = ActiveRecord::Base.connection
    require 'kmdb'
    wau = KMDB::Event.before(au_end).after(wau_start).named('Platform activity').map(&:user_id).uniq.count
    mau = KMDB::Event.before(au_end).after(mau_start).named('Platform activity').map(&:user_id).uniq.count
    dau = KMDB::Event.before(au_end).after(dau_start).named('Platform activity').map(&:user_id).uniq.count
    dashboard.number("Weekly Active Users", wau)
    dashboard.number("Monthly Active Users", mau)
    dashboard.number("Daily Active Users", dau)

    dashboard.number("WAU", wau)
    dashboard.number("MAU", mau)
    dashboard.number("Daily Active", dau)

    ActiveRecord::Base.establish_connection

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
