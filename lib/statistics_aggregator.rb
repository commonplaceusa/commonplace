class StatisticsAggregator
  require 'csv'
  require 'cgi'

  MailGunStatistics = ActiveSupport::JSON.decode(RestClient::Resource.new("https://api:#{$MailgunAPIToken}@api.mailgun.net/v2/#{$MailgunAPIDomain}/stats").get)
  STATISTIC_DAYS = 30

  def self.csv_headers
    ["Date",
      "UsersTotal",
      "PostsTotal",
      "EventsTotal",
      "AnnouncementsTotal",
      "PrivateMessagesTotal",
      "GroupPostsTotal",
      "RepliesTotal",
      "UsersLoggedInOverPast3Months",
      "UsersActiveOverPast30Days",
      "UsersPostingOverPast3Months",
      "UsersGainedDaily",
      "PostsToday",
      "EventsToday",
      "AnnouncementsToday",
      "GroupPostsToday",
      "PrivateMessagesToday",
      "FeedAnnouncementsToday",
      "FeedEventsToday",
      "FeedsPostingToday",
      "PctgFeedsEdited",
      "PctgFeedsStreaming",
      "PctgFeedsPostedEvent",
      "PctgFeedsPostedAnnouncement",
      "TodaysPosts",
      "PostsRepliedToToday",
      "EventsRepliedToToday",
      "AnnouncementsRepliedToToday",
      "GroupPostsRepliedToToday",
      "DailyBulletinsSentToday",
      "DailyBulletinsOpenedToday",
      "DailyBulletinsClickedToday",
      "NeighborhoodPostEmailsSentToday",
      "NeighborhoodPostEmailsOpenedToday",
      "NeighborhoodPostEmailsClickedToday",
      "GroupPostEmailsSentToday",
      "GroupPostEmailsOpenedToday",
      "GroupPostEmailsClickedToday",
      "AnnouncementEmailsSentToday",
      "AnnouncementEmailsOpenedToday",
      "AnnouncementEmailsClickedToday",
      "PostReceivedMessageTotal"].join(",")
  end

  def self.user_total_count(scope, start_date, end_date)
    scope.between(start_date, end_date).count
  end

  def self.logged_in_in_past_30_days(scope, reference_date)
    scope.select { |u| u.last_sign_in_at and u.last_sign_in_at < reference_date and u.last_sign_in_at > reference_date - 30.days }.count
  end

  def self.extract_mailgun_count(event, tag, day)
    ret = 0
    begin
      MailGunStatistics["items"].select { |i|
        i["event"] and i["created_at"] and i["event"] == event and
          Date.parse(i["created_at"]) == day }.each { |e| ret += (e["tags"][tag] || 0) }
    rescue
      ret = 0
    end
    return ret
  end

  def self.csv_statistics_globally
    puts "Processing globally"
    unless Resque.redis.get("statistics:csv:global").present?
      t1 = Time.now
      #launch = [Post.first, Event.first, Announcement.first, GroupPost.first].sort_by(&:created_at).first.created_at.to_datetime
      csv = StatisticsAggregator.csv_headers
      community_launch = Community.first.launch_date.to_date
      launch = STATISTIC_DAYS.days.ago.to_date 
      today = DateTime.now
      launch.upto(today).each do |day|
        reply_count = Reply.between(community_launch.to_datetime, day.to_datetime).count
        user_count = StatisticsAggregator.user_total_count(User, community_launch.to_datetime, day.to_datetime)
        logged_in_in_past_30_days = StatisticsAggregator.logged_in_in_past_30_days(User.all, day.to_datetime)
        daily_bulletin_opens_on_date = StatisticsAggregator.extract_mailgun_count("opened", "daily_bulletin", day)
        users_engaged_in_past_30_days = 0
        #users_posted_in_past_30_days = User.all.select { |u| u.posted_content.present? and u.posted_content.sort_by { |c| c.created_at }.last.created_at > 30.days.ago }.count
        users_posted_in_past_30_days = 0
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
        feed_announcements_today = Announcement.between(day.to_datetime - 1.day, day.to_datetime).select { |a| a.owner.is_a? Feed }.count
        feed_events_today = Event.between(day.to_datetime - 1.day, day.to_datetime).select { |e| e.owner.is_a? Feed }.count
        #feeds_posting_today = Feed.all.select { |f| f.posted_between?(day.to_datetime - 1.day, day.to_datetime) }.count
        feeds_posting_today = 0
        feeds_editing_profile_in_past_month = Feed.updated_between(day.to_datetime - 1.month, day.to_datetime).count * 100 / Feed.count
        feeds_streaming_input = 0 * 100 / Feed.count
        feeds_posting_event_in_past_month = Event.between(day.to_datetime - 1.month, day.to_datetime).select { |e| e.owner.is_a? Feed }.map(&:owner).uniq.count * 100 / Feed.count
        feeds_posting_announcement_in_past_month = Announcement.between(day.to_datetime - 1.month, day.to_datetime).select { |a| a.owner.is_a? Feed }.map(&:owner).uniq.count * 100 / Feed.count
        todays_posts = []
        posts_replied_to_today = Post.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        events_replied_to_today = Event.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        announcements_replied_to_today = Announcement.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        group_posts_replied_to_today = GroupPost.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        daily_bulletins_sent_today = StatisticsAggregator.extract_mailgun_count("sent", "daily_bulletin", day)
        daily_bulletins_opened_today = daily_bulletin_opens_on_date
        daily_bulletin_clicks_today = StatisticsAggregator.extract_mailgun_count("clicks", "daily_bulletin", day)
        neighborhood_post_emails_sent_today = StatisticsAggregator.extract_mailgun_count("sent", "post", day)
        neighborhood_post_emails_opened_today = StatisticsAggregator.extract_mailgun_count("opened", "post", day)
        neighborhood_post_email_clicks_today = StatisticsAggregator.extract_mailgun_count("clicks", "post", day)
        group_post_emails_sent_today = StatisticsAggregator.extract_mailgun_count("sent", "group_post", day)
        group_post_emails_opened_today = StatisticsAggregator.extract_mailgun_count("opened", "group_post", day)
        group_post_email_clicks_today = StatisticsAggregator.extract_mailgun_count("clicks", "group_post", day)
        announcement_emails_sent_today = StatisticsAggregator.extract_mailgun_count("sent", "announcement", day)
        announcement_emails_opened_today = StatisticsAggregator.extract_mailgun_count("opened", "announcement", day)
        announcement_email_clicks_today = StatisticsAggregator.extract_mailgun_count("clicks", "announcement", day)

        posts_received_message_response = 0

        csv_arr = [day.strftime("%m/%d/%Y"),
         user_count,
         post_count,
         event_count,
         announcement_count,
         private_message_count,
         group_post_count,
         reply_count,
         logged_in_in_past_30_days,
         users_engaged_in_past_30_days,
         users_posted_in_past_30_days,
         users_gained,
         posts_today,
         events_today,
         announcements_today,
         group_posts_today,
         private_messages_today,
         feed_announcements_today,
         feed_events_today,
         feeds_posting_today,
         feeds_editing_profile_in_past_month,
         feeds_streaming_input,
         feeds_posting_event_in_past_month,
         feeds_posting_announcement_in_past_month,
         todays_posts.join(";--;"),
         posts_replied_to_today,
         events_replied_to_today,
         announcements_replied_to_today,
         group_posts_replied_to_today,
         daily_bulletins_sent_today,
         daily_bulletins_opened_today,
         daily_bulletin_clicks_today,
         neighborhood_post_emails_sent_today,
         neighborhood_post_emails_opened_today,
         neighborhood_post_email_clicks_today,
         group_post_emails_sent_today,
         group_post_emails_opened_today,
         group_post_email_clicks_today,
         announcement_emails_sent_today,
         announcement_emails_opened_today,
         announcement_email_clicks_today,
         posts_received_message_response
        ]
        csv = "#{csv}\n#{csv_arr.join(',')}"
      end
      puts "Completed in #{Time.now - t1} seconds"
      Resque.redis.set("statistics:csv:global", csv)
      csv
    else
      Resque.redis.get("statistics:csv:global")
    end
  end

  def self.generate_statistics_csv_for_community(c)
    puts "Processing #{c.slug}"
    t1 = Time.now
    unless Resque.redis.get("statistics:csv:#{c.slug}").present?
      csv = StatisticsAggregator.csv_headers
      today = DateTime.now
      community = c
      community_launch = community.launch_date.to_date || community.users.sort { |a,b| a.created_at <=> b.created_at }.first.created_at.to_date
      launch = [community_launch, STATISTIC_DAYS.days.ago.to_date].max
      launch.upto(today).each do |day|
        reply_count = 0
        replies = community.repliables
        replies.each do |reply_set|
          reply_count += reply_set.select{ |repliable| repliable.between?(launch.to_datetime, day.to_datetime) }.count
        end
        user_count = StatisticsAggregator.user_total_count(community.users, community_launch.to_datetime, day.to_datetime)
        logged_in_in_past_30_days = StatisticsAggregator.logged_in_in_past_30_days(community.users, day.to_datetime)
        daily_bulletin_opens_on_date = 0
        users_engaged_in_past_30_days = 0
        users_posted_in_past_30_days = community.users.select { |u| u.posted_content.present? and u.posted_content.sort_by { |c| c.created_at }.last.created_at > 30.days.ago }.count
        users_gained = community.users.between(day.to_datetime.beginning_of_day, day.to_datetime.end_of_day).count
        post_count = community.posts.between(community_launch.to_datetime, day.to_datetime).count
        event_count = community.events.between(community_launch.to_datetime, day.to_datetime).count
        announcement_count = community.announcements.between(community_launch.to_datetime, day.to_datetime).count
        private_message_count = community.private_messages.between(community_launch.to_datetime, day.to_datetime).count
        group_post_count = community.group_posts.between(community_launch.to_datetime, day.to_datetime).count
        posts_today = community.posts.between(day.to_datetime - 1.day, day.to_datetime).count
        events_today = community.events.between(day.to_datetime - 1.day, day.to_datetime).count
        announcements_today = community.announcements.between(day.to_datetime - 1.day, day.to_datetime).count
        private_messages_today = community.private_messages.between(day.to_datetime - 1.day, day.to_datetime).count
        group_posts_today = community.group_posts.between(day.to_datetime - 1.day, day.to_datetime).count
        feed_announcements_today = community.announcements.between(day.to_datetime - 1.day, day.to_datetime).select { |a| a.owner.is_a? Feed }.count
        feed_events_today = community.events.between(day.to_datetime - 1.day, day.to_datetime).select { |e| e.owner.is_a? Feed }.count
        feeds_posting_today = community.feeds.select { |f| f.posted_between?(day.to_datetime - 1.day, day.to_datetime) }.count
        feeds_editing_profile_in_past_month = community.feeds.updated_between(day.to_datetime - 1.month, day.to_datetime).count * 100 / community.feeds.count
        feeds_streaming_input = 0 * 100 / community.feeds.count
        feeds_posting_event_in_past_month = community.events.between(day.to_datetime - 1.month, day.to_datetime).select { |e| e.owner.is_a? Feed }.map(&:owner).uniq.count * 100 / community.feeds.count
        feeds_posting_announcement_in_past_month = community.announcements.between(day.to_datetime - 1.month, day.to_datetime).select { |a| a.owner.is_a? Feed }.map(&:owner).uniq.count * 100 / community.feeds.count
        todays_posts = community.posts.between(day.to_datetime - 1.day, day.to_datetime).map{ |p| CGI::escapeHTML(p.subject) }
        posts_replied_to_today = community.posts.between(day.to_datetime - 1.month, day.to_datetime).select(&:has_reply).count
        events_replied_to_today = community.events.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        announcements_replied_to_today = community.announcements.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        group_posts_replied_to_today = community.group_posts.between(day.to_datetime - 1.day, day.to_datetime).select(&:has_reply).count
        daily_bulletins_sent_today = 0 # TODO: Tilford's tracking
        daily_bulletins_opened_today = 0 # TODO: Tilford's tracking
        daily_bulletin_clicks_today = 0 # TODO: Tilford's tracking

        neighborhood_post_emails_sent_today = 0 # TODO: Tilford's tracking
        neighborhood_post_emails_opened_today = 0 # TODO: Tilford's tracking
        neighborhood_post_email_clicks_today = 0 # TODO: Tilford's tracking

        group_post_emails_sent_today = 0 # TODO: Tilford's tracking
        group_post_emails_opened_today = 0 # TODO: Tilford's tracking
        group_post_email_clicks_today = 0 # TODO: Tilford's tracking

        announcement_emails_sent_today = 0 # TODO: Tilford's tracking
        announcement_emails_opened_today = 0 # TODO: Tilford's tracking
        announcement_email_clicks_today = 0 # TODO: Tilford's tracking

        posts_received_message_response = 0

        csv_arr = [day.strftime("%m/%d/%Y"),
         user_count,
         post_count,
         event_count,
         announcement_count,
         private_message_count,
         group_post_count,
         reply_count,
         logged_in_in_past_30_days,
         users_engaged_in_past_30_days,
         users_posted_in_past_30_days,
         users_gained,
         posts_today,
         events_today,
         announcements_today,
         group_posts_today,
         private_messages_today,
         feed_announcements_today,
         feed_events_today,
         feeds_posting_today,
         feeds_editing_profile_in_past_month,
         feeds_streaming_input,
         feeds_posting_event_in_past_month,
         feeds_posting_announcement_in_past_month,
         todays_posts.join(";--;"),
         posts_replied_to_today,
         events_replied_to_today,
         announcements_replied_to_today,
         group_posts_replied_to_today,
         daily_bulletins_sent_today,
         daily_bulletins_opened_today,
         daily_bulletin_clicks_today,
         neighborhood_post_emails_sent_today,
         neighborhood_post_emails_opened_today,
         neighborhood_post_email_clicks_today,
         group_post_emails_sent_today,
         group_post_emails_opened_today,
         group_post_email_clicks_today,
         announcement_emails_sent_today,
         announcement_emails_opened_today,
         announcement_email_clicks_today,
         posts_received_message_response
        ]
        csv = "#{csv}\n#{csv_arr.join(',')}"
      end
      t2 = Time.now
      puts "Took #{t2 - t1} seconds"
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

end
