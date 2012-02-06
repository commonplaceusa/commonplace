class StatisticsAggregator
  require 'csv'

  MailGunStatistics = RestClient::Resource.new "https://api:#{$MailgunAPIToken}@api.mailgun.net/v2/#{$MailgunAPIDomain}/stats"

  def self.generate_statistics_csv_for_community(c)
    unless Resque.redis.get("statistics:csv:#{c.slug}").present?
      csv = "Date,UsersTotal,PostsTotal,EventsTotal,AnnouncementsTotal,PrivateMessagesTotal,GroupPostsTotal,UsersLoggedInOverPast3Months,UsersActiveOverPast30Days,UsersPostingOverPast3Months,UsersGainedDaily"
      today = DateTime.now
      community = c
      launch = community.launch_date.to_date || community.users.sort{ |a,b| a.created_at <=> b.created_at }.first.created_at.to_date
      launch.upto(today).each do |day|
        #reply_count = 0
        #replies = community.repliables
        #replies.each do |reply_set|
        #  reply_count += reply_set.select{ |repliable| repliable.between?(launch.to_datetime, day.to_datetime) }.count
        #end
        user_count = community.users.between(launch.to_datetime, day.to_datetime).count
        logged_in_in_past_30_days = community.users.select { |u| u.last_sign_in_at and u.last_sign_in_at < day.to_datetime and u.last_sign_in_at > day.to_datetime - 30.days }.count
        daily_bulletin_opens_on_date = 0
        users_engaged_in_past_30_days = 0
        users_posted_in_past_30_days = 0
        users_gained = community.users.between(day.to_datetime.beginning_of_day, day.to_datetime.end_of_day).count
        post_count = community.posts.between(launch.to_datetime, day.to_datetime).count
        event_count = community.events.between(launch.to_datetime, day.to_datetime).count
        announcement_count = community.announcements.between(launch.to_datetime, day.to_datetime).count
        private_message_count = community.private_messages.select { |m| m.between?(launch.to_datetime, day.to_datetime) }.count
        group_post_count = community.group_posts.select { |p| p.between?(launch.to_datetime, day.to_datetime) }.count
        #csv = "#{csv}\n#{day.strftime("%m/%d/%Y")},#{user_count},#{post_count},#{event_count},#{announcement_count},#{private_message_count},#{group_post_count},#{reply_count}"
        csv = "#{csv}\n#{day.strftime("%m/%d/%Y")},#{user_count},#{post_count},#{event_count},#{announcement_count},#{private_message_count},#{group_post_count},#{logged_in_in_past_30_days},#{users_engaged_in_past_30_days},#{users_posted_in_past_30_days},#{users_gained}"
      end
      Resque.redis.set("statistics:csv:#{c.slug}", csv)
      csv
    else
      Resque.redis.get("statistics:csv:#{c.slug}")
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
