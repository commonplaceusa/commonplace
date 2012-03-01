class StatisticsAggregator
  require 'csv'
  require 'cgi'

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
      "NeighborhoodPostEmailsSentToday",
      "NeighborhoodPostEmailsOpenedToday",
      "GroupPostEmailsSentToday",
      "GroupPostEmailsOpenedToday",
      "AnnouncementEmailsSentToday",
      "AnnouncementEmailsOpenedToday",
      "PostReceivedMessageTotal",
      "UsersAddedDataPast6Months",
      "UsersPostedNeighborhoodPostPast6Months",
      "UsersRepliedPast6Months",
      "UsersPostedEventPast6Months",
      "UsersPostedAnnouncementPast6Months",
      "UsersPostedGroupPostPast6Months",
      "UsersPrivateMessagedPast6Months",
      "UsersUpdatedProfilePast6Months",
      "UsersThankedPast6Months",
      "UsersMettedPast6Months",
      "OffersPosted",
      "RequestsPosted",
      "MeetUpsPosted",
      "ConversationsPosted"
    ].join(",")
  end

  def self.user_total_count(scope, start_date, end_date)
    scope.between(start_date, end_date).count
  end

  def self.logged_in_in_past_30_days(scope, reference_date)
    scope.select { |u| u.last_sign_in_at and u.last_sign_in_at < reference_date and u.last_sign_in_at > reference_date - 30.days }.count
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
        daily_bulletins_sent_today = SentEmail.count('$and' => [{:main_tag => "daily_bulletin"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        daily_bulletins_opened_today = SentEmail.count('$and' => [{:main_tag => "daily_bulletin"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        daily_bulletin_opens_on_date = daily_bulletins_opened_today
        neighborhood_post_emails_sent_today = SentEmail.count('$and' => [{:main_tag => "post"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        neighborhood_post_emails_opened_today = SentEmail.count('$and' => [{:main_tag => "post"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        group_post_emails_sent_today = SentEmail.count('$and' => [{:main_tag => "group_post"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        group_post_emails_opened_today = SentEmail.count('$and' => [{:main_tag => "group_post"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        announcement_emails_sent_today = SentEmail.count('$and' => [{:main_tag => "announcement"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        announcement_emails_opened_today = SentEmail.count('$and' => [{:main_tag => "announcement"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])

        email_open_times = SentEmail.where(:status => 'opened').map { |email| email.updated_at.hour }.count

        users_added_data_past_6_months = [
          Post.between((day - 6.months).to_datetime, day.to_datetime).pluck(:user_id).uniq,
          Event.between((day - 6.months).to_datetime, day.to_datetime).where("owner_type = 'User'").pluck(:owner_id).uniq,
          GroupPost.between((day - 6.months).to_datetime, day.to_datetime).pluck(:user_id).uniq,
          Announcement.between((day - 6.months).to_datetime, day.to_datetime).where("owner_type = 'User'").pluck(:owner_id).uniq
        ].reduce { |ids, more_ids| ids | more_ids }.size
        users_posted_neighborhood_post_past_6_months = User.joins(:posts).where("(select count(id) from posts where posts.user_id = users.id and posts.created_at > ? and posts.created_at < ?) > 0", day - 6.months, day).count
        users_replied_past_6_months = User.find(Reply.where("? < created_at and created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count
        users_posted_event_past_6_months = User.find(Event.where("owner_type = 'User' and ? < created_at and created_at < ?", day - 6.months, day).uniq(:owner_id).pluck(:owner_id)).count
        users_posted_announcement_past_6_months = User.find(Announcement.where("owner_type = 'User' and ? < created_at and created_at < ?", day - 6.months, day).uniq(:owner_id).pluck(:owner_id)).count
        users_posted_group_post_past_6_months = User.find(GroupPost.where("? < created_at and created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count
        users_private_messaged_past_6_months = User.find(Message.where("? < created_at and created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count
        users_updated_profile_past_6_months = User.where("updated_at > ? and updated_at < ?", day - 6.months, day).count

        users_thanked_past_6_months = User.find(Thank.where("? < created_at and created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count

        users_metted_past_6_months = User.joins(:mets).where("(select count(id) from mets where (requestee_id = users.id OR requester_id = users.id) AND ? < mets.created_at AND mets.created_at < ?) > 0", day - 6.months, day).count

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
         neighborhood_post_emails_sent_today,
         neighborhood_post_emails_opened_today,
         group_post_emails_sent_today,
         group_post_emails_opened_today,
         announcement_emails_sent_today,
         announcement_emails_opened_today,
         posts_received_message_response,
         users_added_data_past_6_months,
         users_posted_neighborhood_post_past_6_months,
         users_replied_past_6_months,
         users_posted_event_past_6_months,
         users_posted_announcement_past_6_months,
         users_posted_group_post_past_6_months,
         users_private_messaged_past_6_months,
         users_updated_profile_past_6_months,
         users_thanked_past_6_months,
         users_metted_past_6_months
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

        daily_bulletins_sent_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "daily_bulletin"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        daily_bulletins_opened_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "daily_bulletin"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        neighborhood_post_emails_sent_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "post"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        neighborhood_post_emails_opened_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "post"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        group_post_emails_sent_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "group_post"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        group_post_emails_opened_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "group_post"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])
        announcement_emails_sent_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "announcement"},{:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}])
        announcement_emails_opened_today = SentEmail.count('$and' => [{:originating_community_id => community.id}, {:main_tag => "announcement"}, {:created_at => {'$gt' => day.to_time - 1.day, '$lt' => day.to_time}}, {:status => 'opened'}])

        email_open_times = SentEmail.where('$and' => [{:originating_community_id => community.id}, {:status => 'opened'}]).map { |email| email.updated_at.hour }.count

        users_added_data_past_6_months = [
          community.posts.between((day - 6.months).to_datetime, day.to_datetime).pluck(:user_id).uniq,
          community.events.between((day - 6.months).to_datetime, day.to_datetime).where("owner_type = 'User'").pluck(:owner_id).uniq,
          community.group_posts.between((day - 6.months).to_datetime, day.to_datetime).pluck(:user_id).uniq,
          community.announcements.between((day - 6.months).to_datetime, day.to_datetime).where("owner_type = 'User'").pluck(:owner_id).uniq
        ].reduce { |ids, more_ids| ids | more_ids }.size
        users_posted_neighborhood_post_past_6_months = User.joins(:posts).where("(select count(id) from posts where posts.user_id = users.id and posts.created_at > ? and posts.created_at < ?) > 0", day - 6.months, day).count
        users_replied_past_6_months = 0 #User.find(community.replies.where("? < created_at and created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count
        users_posted_event_past_6_months = 0 #User.find(community.events.where("owner_type = 'User' and ? < created_at and created_at < ?", day - 6.months, day).uniq(:owner_id).pluck(:owner_id).uniq).count
        users_posted_announcement_past_6_months = User.find(community.announcements.where("owner_type = 'User' and ? < created_at and created_at < ?", day - 6.months, day).pluck(:owner_id).uniq).count
        users_posted_group_post_past_6_months = User.find(community.group_posts.where("? < group_posts.created_at and group_posts.created_at < ?", day - 6.months, day).pluck(:user_id).uniq).count
        users_private_messaged_past_6_months = User.find(community.messages.where("? < messages.created_at and messages.created_at < ?", day - 6.months, day).pluck(:user_id).uniq).count
        users_updated_profile_past_6_months = community.users.where("updated_at > ? and updated_at < ?", day - 6.months, day).count

        users_thanked_past_6_months = 0 #User.find(community.thanks.where("? < thanks.created_at and thanks.created_at < ?", day - 6.months, day).uniq(:user_id).pluck(:user_id)).count

        users_metted_past_6_months = community.users.joins(:mets).where("(select count(id) from mets where (requestee_id = users.id OR requester_id = users.id) AND ? < mets.created_at AND mets.created_at < ?) > 0", day - 6.months, day).count

        posts_received_message_response = 0

        offers_posted = community.posts.where("category = 'offers'").count
        requests_posted = community.posts.where("category = 'help'").count
        meetups_posted = community.posts.where("category = 'meetups'").count
        conversations_posted = community.posts.where("category = 'neighborhood'").count

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
         neighborhood_post_emails_sent_today,
         neighborhood_post_emails_opened_today,
         group_post_emails_sent_today,
         group_post_emails_opened_today,
         announcement_emails_sent_today,
         announcement_emails_opened_today,
         posts_received_message_response,
         users_added_data_past_6_months,
         users_posted_neighborhood_post_past_6_months,
         users_replied_past_6_months,
         users_posted_event_past_6_months,
         users_posted_announcement_past_6_months,
         users_posted_group_post_past_6_months,
         users_private_messaged_past_6_months,
         users_updated_profile_past_6_months,
         users_thanked_past_6_months,
         users_metted_past_6_months,
         offers_posted,
         requests_posted,
         meetups_posted,
         conversations_posted
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
