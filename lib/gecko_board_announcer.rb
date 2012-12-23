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
    (100 * (penetrations.inject{ |sum, el| sum + el }.to_f / communities.size)).round(3)
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
    network_size_headers = ["Age", "# of Networks", "Avg Size", "Avg Pen"]
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
      c.launch_date >= Date.today - 4.months and c.launch_date < Date.today - 1.month
    end
    third_bucket = Community.all.select do |c|
      c.launch_date >= Date.today - 11.months and c.launch_date < Date.today - 4.month
    end
    network_sizes << ["1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)].map(&:to_s)
    network_sizes << ["4m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)].map(&:to_s)
    network_sizes << ["11m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)].map(&:to_s)
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

    # Organic growth
    # growth_breakdown << ["Organic Growth", "", organic_users.count.to_s]
    # Launch growth
    # growth_breakdown << ["Launch Growth (<= 3m)", "", launch_users.count.to_s]

    # dashboard.table("Growth Breakdown", growth_breakdown)
    dashboard.pie("Growth Breakdown Pie", [
      { "Organic" => organic_users.count },
      { "Paid" => launch_users.count }
    ])

    puts "Computing post distribution..."
    # Post distribution
    post_distribution = [["", "#", "Replies"]]
    posts = Post.where(category: "help")
    post_distribution << ["Questions", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    posts = Post.where(category: "offers")
    post_distribution << ["Marketplaces", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    posts = Event.all
    post_distribution << ["Events", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    posts = Post.where(category: "neighborhood")
    post_distribution << ["Town Discussions", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    posts = Announcement.all
    post_distribution << ["Announcements", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)
    posts = Message.all
    post_distribution << ["Private Messages", posts.count, posts.map(&:replies).flatten.count].map(&:to_s)

    dashboard.table("Post Breakdown", post_distribution)

    puts "Computing growths..."
    growths = growths.sort_by do |v|
      v[1]
    end.append(growth_headers).reverse
    dashboard.table("Growth by Community", growths)
    dashboard.pie("Population by Community", populations)

    puts "Computing penetrations..."
    dashboard.number("Overall Penetration", average_penetration(Community.all))

    puts "Computing growth rates..."
    growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
    dashboard.number("Overall Weekly Growth Rate", 100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f)

    puts "Getting email values..."
    # dashboard.number("Daily Bulletins Sent Today", DailyStatistic.value("daily_bulletins_sent") || 0)
    # dashboard.number("Daily Bulletins Opened Today", DailyStatistic.value("daily_bulletins_opened") || 0)
    # # dashboard.number("Daily Bulletin Open Rate Today", DailyStatistic.value("daily_bulletins_opened").to_f / DailyStatistic.value("daily_bulletins_sent").to_f)
    # dashboard.number("Single Post Emails Sent Today", DailyStatistic.value("single_posts_sent") || 0)
    # dashboard.number("Single Post Emails Opened Today", DailyStatistic.value("single_posts_opened") || 0)
    # # dashboard.number("Single Post Email Open Rate Today", DailyStatistic.value("single_posts_opened").to_f / DailyStatistic.value("single_posts_sent").to_f)
    # # emails = []
    # # Resque.redis.keys("statistics:daily:*_sent").each do |key|
      # # email_tag = key.gsub("statistics:daily:", "").gsub("_sent", "")
      # # emails << {
        # # email_tag => Resque.redis.get(key).to_i
      # # }
    # # end
    # # dashboard.pie("Todays Emails by Tag", emails)
    # #
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

    puts "Computing reply percentages..."
    all_posts = Post.all + Announcement.all + GroupPost.all + Event.all

    reply_pctg = 100 * (all_posts.select { |r| r.replies.any? }.count.to_f / all_posts.count.to_f).round(2)
    dashboard.number("Reply Percent", reply_pctg) # TODO: Fix this number to include privatemessages

    puts "Computing posts per network..."
    items = Post.all #all_posts.uniq
    total = items.count
    posts_per_network = total / items.compact.map { |c| c.try(:community) }.uniq.compact.count
    dashboard.number("Posts per Network", posts_per_network)

    # dashboard.number("Active Workers", HerokuResque::WorkerScaler.count("worker"))

    # dashboard.number("E-Mails in Queue", Resque.size("notifications"))

    # dashboard.text("Statistics Information", "Update Finished", "Finished updating at #{DateTime.now.in_time_zone(tz).to_s}")

    puts "Doing AUs..."
    wau_start = 1.week.ago - 2.days
    mau_start = 1.month.ago - 2.days
    dau_start = 1.day.ago - 2.days
    au_end = wau_start + 1.week - 2.days

    # raise "Starting MAU calculation"

    # This has to happen last, since it messes with ActiveRecord
    if Rails.env.production?
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
    end

    puts "Done"

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
