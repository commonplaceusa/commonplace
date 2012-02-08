class StatisticsAggregator
  require 'csv'

  MailGunStatistics = RestClient::Resource.new "https://api:#{$MailgunAPIToken}@api.mailgun.net/v2/#{$MailgunAPIDomain}/stats"

  def self.csv_headers
    "Date,UsersTotal,PostsTotal,EventsTotal,AnnouncementsTotal,PrivateMessagesTotal,GroupPostsTotal,UsersLoggedInOverPast3Months,UsersActiveOverPast30Days,UsersPostingOverPast3Months,UsersGainedDaily,PostsToday,EventsToday,AnnouncementsToday,GroupPostsToday,PrivateMessagesToday"
  end

  def self.user_total_count(scope, start_date, end_date)
    scope.between(start_date, end_date).count
  end

  def self.logged_in_in_past_30_days(scope, reference_date)
    scope.select { |u| u.last_sign_in_at and u.last_sign_in_at < reference_date and u.last_sign_in_at > reference_date - 30.days }.count
  end

  def self.csv_statistics_globally
    unless Resque.redis.get("statistics:csv:global").present?
      #launch = [Post.first, Event.first, Announcement.first, GroupPost.first].sort_by(&:created_at).first.created_at.to_datetime
      csv = StatisticsAggregator.csv_headers
      community_launch = Community.first.launch_date.to_date
      launch = 2.days.ago.to_date 
      today = DateTime.now
      launch.upto(today).each do |day|
        user_count = StatisticsAggregator.user_total_count(User, community_launch.to_datetime, day.to_datetime)
        logged_in_in_past_30_days = StatisticsAggregator.logged_in_in_past_30_days(User.all, day.to_datetime)
        daily_bulletin_opens_on_date = 0
        users_engaged_in_past_30_days = 0
        users_posted_in_past_30_days = User.all.select { |u| u.posted_content.present? and u.posted_content.sort_by { |c| c.created_at }.last.created_at > 30.days.ago }.count
        users_gained = User.between(day.to_datetime.beginning_of_day, day.to_datetime.end_of_day).count
        post_count = Post.between(community_launch.to_datetime, day.to_datetime).count
        event_count = Event.between(community_launch.to_datetime, day.to_datetime).count
        announcement_count = Announcement.between(community_launch.to_datetime, day.to_datetime).count
        private_message_count = Message.between(community_launch.to_datetime, day.to_datetime).count
        group_post_count = GroupPost.between(community_launch.to_datetime, day.to_datetime).count
        posts_today = Post.between(day.to_datetime - 1.day, day.to_datetime).count
        events_today = Event.between(day.to_datetime - 1.day, day.to_datetime).count
        announcements_today = Announcement.between(day.to_datetime - 1.day, day.to_datetime).count
        private_messages_today = Message.between(day.to_datetime - 1.day, day.to_datetime).count
        group_posts_today = GroupPost.between(day.to_datetime - 1.day, day.to_datetime).count
        csv = "#{csv}\n#{day.strftime("%m/%d/%Y")},#{user_count},#{post_count},#{event_count},#{announcement_count},#{private_message_count},#{group_post_count},#{logged_in_in_past_30_days},#{users_engaged_in_past_30_days},#{users_posted_in_past_30_days},#{users_gained},#{posts_today},#{events_today},#{announcements_today},#{group_posts_today},#{private_messages_today}"
      end
      Resque.redis.set("statistics:csv:global", csv)
      csv
    else
      Resque.redis.get("statistics:csv:global")
    end
  end

  def self.generate_statistics_csv_for_community(c)
    unless Resque.redis.get("statistics:csv:#{c.slug}").present?
      csv = StatisticsAggregator.csv_headers
      today = DateTime.now
      community = c
      community_launch = community.launch_date.to_date || community.users.sort { |a,b| a.created_at <=> b.created_at }.first.created_at.to_date
      launch = [community_launch, 2.days.ago.to_date].max
      launch.upto(today).each do |day|
        #reply_count = 0
        #replies = community.repliables
        #replies.each do |reply_set|
        #  reply_count += reply_set.select{ |repliable| repliable.between?(launch.to_datetime, day.to_datetime) }.count
        #end
        user_count = StatisticsAggregator.user_total_count(community.users, community_launch.to_datetime, day.to_datetime)
        logged_in_in_past_30_days = StatisticsAggregator.logged_in_in_past_30_days(community.users, day.to_datetime)
        daily_bulletin_opens_on_date = 0
        users_engaged_in_past_30_days = 0
        users_posted_in_past_30_days = community.users.select { |u| u.posted_content.present? and u.posted_content.sort_by { |c| c.created_at }.last.created_at > 30.days.ago }.count
        users_gained = community.users.between(day.to_datetime.beginning_of_day, day.to_datetime.end_of_day).count
        post_count = community.posts.between(community_launch.to_datetime, day.to_datetime).count
        event_count = community.events.between(community_launch.to_datetime, day.to_datetime).count
        announcement_count = community.announcements.between(community_launch.to_datetime, day.to_datetime).count
        private_message_count = community.private_messages({:between => [community_launch.to_datetime, day.to_datetime]}).count
        group_post_count = community.group_posts({:between => [community_launch.to_datetime, day.to_datetime]}).count
        posts_today = community.posts.between(day.to_datetime - 1.day, day.to_datetime).count
        events_today = community.events.between(day.to_datetime - 1.day, day.to_datetime).count
        announcements_today = community.announcements.between(day.to_datetime - 1.day, day.to_datetime).count
        private_messages_today = community.private_messages({:between => [day.to_datetime - 1.day, day.to_datetime]}).count
        group_posts_today = community.group_posts({:between => [day.to_datetime - 1.day, day.to_datetime]}).count
        #csv = "#{csv}\n#{day.strftime("%m/%d/%Y")},#{user_count},#{post_count},#{event_count},#{announcement_count},#{private_message_count},#{group_post_count},#{reply_count}"
        csv = "#{csv}\n#{day.strftime("%m/%d/%Y")},#{user_count},#{post_count},#{event_count},#{announcement_count},#{private_message_count},#{group_post_count},#{logged_in_in_past_30_days},#{users_engaged_in_past_30_days},#{users_posted_in_past_30_days},#{users_gained},#{posts_today},#{events_today},#{announcements_today},#{group_posts_today},#{private_messages_today}"
      end
      Resque.redis.set("statistics:csv:#{c.slug}", csv)
      csv
    else
      Resque.redis.get("statistics:csv:#{c.slug}")
    end
  end

  def self.generate_hashed_statistics_globally
    unless Resque.redis.get("statistics:hashed:global").present?
      data = CSV.parse(StatisticsAggregator.csv_statistics_globally)
      headers = data.shift.map &:to_s
      string_data = data.map { |row| row.map(&:to_s) }
      array_of_hashes = string_data.map { |row| Hash[*headers.zip(row).flatten] }
      Resque.redis.set("statistics:hashed:global", ActiveSupport::JSON.encode(array_of_hashes))
      array_of_hashes
    else
      Resque.redis.get("statistics:hashed:global")
    end
  end

  def self.generate_hashed_statistics_for_community(c)
    unless Resque.redis.get("statistics:hashed:#{c.slug}").present?
      #csv = CSV.new(StatisticsAggregator.csv_statistics_for_community(c), {})
      data = CSV.parse(StatisticsAggregator.csv_statistics_for_community(c))
      headers = data.shift.map &:to_s
      string_data = data.map { |row| row.map(&:to_s) }
      array_of_hashes = string_data.map { |row| Hash[*headers.zip(row).flatten] }
      Resque.redis.set("statistics:hashed:#{c.slug}", ActiveSupport::JSON.encode(array_of_hashes))
      array_of_hashes
    else
      Resque.redis.get("statistics:hashed:#{c.slug}")
    end
  end

  def self.csv_statistics_for_community(community)
    Resque.redis.get("statistics:csv:#{community.slug}")
  end

  def self.statistics_for_community_between_days_ago(c, yday, tday)
    community_average_days = StatisticsAggregator.average_days(c) || AVERAGE_DAYS
    result = {}
    result[:total_users] = User.between(c.launch_date.to_datetime,tday.days.ago).select { |u| u.community == c}.count
    result[:user_gains_today] = User.between(yday.days.ago.utc, tday.days.ago).select {|u| u.community == c}.count

    result[:percentage_of_field] = (result[:total_users] / c.households.to_f).round(4)

    result[:neighborhood_posts_today] = c.posts.between(yday.days.ago, tday.days.ago).count
    result[:average_neighborhood_posts_daily] = (c.posts.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(6)

    result[:announcements_today] = c.announcements.between(yday.days.ago, tday.days.ago).count
    result[:average_announcements_daily] = (c.announcements.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(6)

    result[:events_today] = c.events.between(yday.days.ago, tday.days.ago).count
    result[:average_events_daily] = (c.events.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(6)

    result[:private_messages_today] = Message.between(yday.days.ago, tday.days.ago).select { |m| m.user.community == c}.count
    result[:average_private_messages_daily] = (Message.between(community_average_days.days.ago, tday.days.ago).select { |m| m.user.community == c}.count / community_average_days).round(6)

    result[:replies_today] = Reply.between(yday.day.ago, tday.days.ago).select { |r| r.user.community == c }.count
    result[:average_replies_daily] = (Reply.between(community_average_days.days.ago, tday.days.ago).select { |r| r.user.community == c }.count / community_average_days).round(6)

    result[:group_posts_today] = c.group_posts.select { |p| p.between?(yday.days.ago, tday.days.ago) }.count
    result[:average_group_posts_daily] = (c.group_posts.select { |p| p.between?(community_average_days.days.ago, tday.days.ago) }.count / community_average_days).round(6)
    
    result
  end
end
