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
    # puts "Computing network sizes..."
    # first_bucket = Community.all.select do |c|
      # c.launch_date >= Date.today - 1.month
    # end
    # second_bucket = Community.all.select do |c|
      # c.launch_date >= Date.today - 4.months and c.launch_date < Date.today - 1.month
    # end
    # third_bucket = Community.all.select do |c|
      # c.launch_date >= Date.today - 11.months and c.launch_date < Date.today - 4.month
    # end
    # network_sizes << ["1m", first_bucket.count, average_size(first_bucket), average_penetration(first_bucket)].map(&:to_s)
    # network_sizes << ["4m", second_bucket.count, average_size(second_bucket), average_penetration(second_bucket)].map(&:to_s)
    # network_sizes << ["11m", third_bucket.count, average_size(third_bucket), average_penetration(third_bucket)].map(&:to_s)
    # network_sizes << ["TOTAL", Community.all.count, average_size(Community.all), average_penetration(Community.all)].map(&:to_s)

    # dashboard.table("Community Sizes", network_sizes)

    # puts "Computing organic and paid growth..."

    # # Break down growth by organic vs not organic
    # growth_breakdown = [["", "%", "# of users"]]

    # all_users = User.all
    # launch_users = all_users.select do |u|
      # u.created_at.to_date <= (u.community.launch_date + 3.months).to_date
    # end
    # organic_users = all_users - launch_users

    # dashboard.pie("Growth Breakdown Pie", [
      # { "Organic" => organic_users.count },
      # { "Paid" => launch_users.count }
    # ])

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

    # puts "Computing penetrations..."
    # dashboard.number("Overall Penetration", average_penetration(Community.all))

    # puts "Computing growth rates..."
    # growth_rates = Community.all.reject { |c| EXCLUDED_COMMUNITIES.include? c.slug }.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
    # dashboard.number("Overall Weekly Growth Rate", 100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f)

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
