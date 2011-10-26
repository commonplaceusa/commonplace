class StatisticsAggregator

  AVERAGE_DAYS = 7.0
  HISTORICAL_DAYS = 5
  DATA_UNAVAILABLE_MESSAGE = "N/A"

  MailGunStatistics = RestClient::Resource.new "https://api:#{$MailgunAPIToken}@api.mailgun.net/v2/#{$MailgunAPIDomain}/stats"

  NETWORK_SIZE = User.count

  def self.statistics_for_community_between_days_ago(c, yday, tday)
    community_average_days = StatisticsAggregator.average_days(c) || AVERAGE_DAYS
    result = {}
    result[:total_users] = User.between(StatisticsAggregator.first_day(c).to_datetime,tday.days.ago).select { |u| u.community == c}.count
    result[:user_gains_today] = User.between(yday.days.ago.utc, tday.days.ago).select {|u| u.community == c}.count

    result[:percentage_of_field] = DATA_UNAVAILABLE_MESSAGE

    result[:neighborhood_posts_today] = c.posts.between(yday.days.ago, tday.days.ago).count
    result[:average_neighborhood_posts_daily] = (c.posts.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(2)

    result[:announcements_today] = c.announcements.between(yday.days.ago, tday.days.ago).count
    result[:average_announcements_daily] = (c.announcements.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(2)

    result[:events_today] = c.events.between(yday.days.ago, tday.days.ago).count
    result[:average_events_daily] = (c.events.between(community_average_days.days.ago, tday.days.ago).count / community_average_days).round(2)

    result[:private_messages_today] = Message.between(yday.days.ago, tday.days.ago).select { |m| m.user.community == c}.count
    result[:average_private_messages_daily] = (Message.between(community_average_days.days.ago, tday.days.ago).select { |m| m.user.community == c}.count / community_average_days).round(2)

    result[:replies_today] = Reply.between(yday.day.ago, tday.days.ago).select { |r| r.user.community == c }.count
    result[:average_replies_daily] = (Reply.between(AVERAGE_DAYS.days.ago, tday.days.ago).select { |r| r.user.community == c }.count / AVERAGE_DAYS).round(2)

    result[:group_posts_today] = GroupPost.between(yday.days.ago, tday.days.ago).select{|p| p.user.community == c}.count
    result[:average_group_posts_daily] = (GroupPost.between(community_average_days.days.ago, tday.days.ago).select{|p| p.user.community == c}.count / community_average_days).round(2)
    result
  end

  def self.historical_statistics_for_community(community, days)
    result = {}
    day_counter = 0
    while day_counter <= days do
      # Generate statistics between day_counter+1.days.ago and day_counter.days.ago
      result[day_counter] = StatisticsAggregator.statistics_for_community_between_days_ago(community, day_counter + 1, day_counter)
      day_counter += 1
    end
    result
  end

  def self.perform
    # Prepare to access Google Analytics
    Garb::Session.login($GoogleAnalyticsAPILogin, $GoogleAnalyticsAPIPassword)
    profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == $GoogleAnalyticsPropertyID}
    # Aggregate platform-wide statistics (for every community)
    communities = {}
    historical = {}
    overall = {}
    Community.all.select{|c| c.core and c.posts.present?}.each do |c|
      historical[c.name] = StatisticsAggregator.historical_statistics_for_community(c, HISTORICAL_DAYS)
      communities[c.name] = historical[c.name][0]
    end

    overall[:page_views_today] = GoogleAnalytics::Pageviews.results(profile, :start_date => 1.day.ago, :end_date => 0.days.ago).first.pageviews.to_i
    overall[:page_views_this_week] = GoogleAnalytics::Pageviews.results(profile, :start_date => 7.days.ago, :end_date => 0.days.ago).first.pageviews.to_i
    overall[:average_page_views_per_day] = (GoogleAnalytics::Pageviews.results(profile, :start_date => AVERAGE_DAYS.day.ago, :end_date => 0.days.ago).first.pageviews.to_i / AVERAGE_DAYS).round(2)

    overall[:unique_platform_visits_today] = DATA_UNAVAILABLE_MESSAGE
    overall[:average_number_of_visitors_daily] = DATA_UNAVAILABLE_MESSAGE

    overall[:network_engagement_daily] = DATA_UNAVAILABLE_MESSAGE
    overall[:network_engagement_weekly] = DATA_UNAVAILABLE_MESSAGE
    overall[:average_time_spent_on_platform] = DATA_UNAVAILABLE_MESSAGE

    overall[:average_percent_of_emails_read] = (StatisticsAggregator.email_open_pctg())

    overall[:percent_of_network_adding_data] = DATA_UNAVAILABLE_MESSAGE

    overall[:average_number_of_profile_adds_daily] = DATA_UNAVAILABLE_MESSAGE
    overall[:percentage_with_profile_photos] = DATA_UNAVAILABLE_MESSAGE
    overall[:percentage_with_tags_in_profile] = DATA_UNAVAILABLE_MESSAGE

    overall[:number_of_profile_clicks] = DATA_UNAVAILABLE_MESSAGE
    overall[:average_profile_clicks_per_visitor] = DATA_UNAVAILABLE_MESSAGE
    overall[:number_of_searches] = DATA_UNAVAILABLE_MESSAGE
    overall[:average_number_of_searches_per_visitor] = DATA_UNAVAILABLE_MESSAGE

    overall[:average_load_time] = DATA_UNAVAILABLE_MESSAGE

    Resque.redis.set COMMUNITY_STATISTICS_BUCKET, ActiveSupport::JSON.encode(communities)
    Resque.redis.set OVERALL_STATISTICS_BUCKET, ActiveSupport::JSON.encode(overall)
    Resque.redis.set HISTORICAL_STATISTICS_BUCKET, ActiveSupport::JSON.encode(historical)
  end

  def self.emails_opened
    emails_opened = 0
    params = {}
    params[:event] = 'opened'
    result = ActiveSupport::JSON.decode(MailGunStatistics.get({:params => params}))
    result['items'].each do |obj|
      emails_opened += obj['total_count'].to_i
    end
    return emails_opened
  end

  def self.emails_sent
    emails_sent = 0
    params = {}
    params[:event] = 'sent'
    result = ActiveSupport::JSON.decode(MailGunStatistics.get({:params => params}))
    result['items'].each do |obj|
      emails_sent += obj['total_count'].to_i
    end
    return emails_sent
  end

  def self.email_open_pctg
    return "#{100 * StatisticsAggregator.emails_opened.to_f / StatisticsAggregator.emails_sent.to_f.round(2)}%"
  end

  def self.first_day(community)
    community.posts.last.created_at.to_date
  end

  def self.average_days(community)
    r = 0
    StatisticsAggregator.first_day(community).upto(DateTime.now) do |day|
      r += 1
    end
    r
  end

end
