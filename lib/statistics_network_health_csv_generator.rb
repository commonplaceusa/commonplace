class StatsFormatter
  DECIMAL_PRECISION = 2

  def self.percent(number)
    "#{StatsFormatter.decimal(number, 4) * 100}%"
  end

  def self.decimal(number, precision = StatsFormatter::DECIMAL_PRECISION)
    number.round(precision)
  end
end
class NetworkHealthStats

  DECIMAL_PRECISION = 2
  def self.core_communities
    Community.where("core = true")
  end

  def self.percent_growth(start, finish)
    StatsFormatter::percent(User.core.between(start, finish).count.to_f / User.core.up_to(start).count.to_f)
  end

  def self.items_per_day_per_community(start, finish, klass)
    days = 7
    (klass.core.between(start, finish).count.to_f / (days * core_communities.count)).round(DECIMAL_PRECISION)
  end

  def self.daily_bulletin_open_rate(start, finish)
    opened = SentEmail.count('$and' => [{:tag_list => "daily_bulletin"},{:updated_at => {'$gt' => start.to_time, '$lt' => finish.to_time}}, {:status => 'opened'}])
    sent = SentEmail.count('$and' => [{:tag_list => "daily_bulletin"},{:updated_at => {'$gt' => start.to_time, '$lt' => finish.to_time}}])
    StatsFormatter::percent(opened.to_f / sent.to_f)
  end

  def self.platform_engagement(start, finish)
    SiteVisit.where('$and' => [{:created_at => {'$gt' => start.to_time, '$lt' => finish.to_time.end_of_day}}]).all.map(&:commonplace_account_id).uniq.count
  end

  def self.users_for_community(finish, community)
    community.users.up_to(finish).count
  end

  def self.new_users_for_community_in_date_range(start, finish, community)
    community.users.between(start, finish).count
  end

  def self.new_items_for_community_in_date_range(start, finish, community, item)
    item.where(community_id: community.id).between(start, finish).count
  end

  def self.daily_bulletin_opens_for_community(start, finish, community)
    SentEmail.where(updated_at: {
              '$gte' => start.utc.to_time, # Translation: $gte means 'greater than or equal'
              '$lte' => finish.utc.to_time # Translation: similar
    }).where(originating_community_id: community.id).where(tag_list: 'daily_bulletin').where(status: 'opened').count
  end

  def self.unique_visit_count_for_community(start, finish, community)
    SiteVisit.where(community_id: community.id).where(
      created_at: {
        '$gte' => start.utc.to_time,
        '$lte' => finish.utc.to_time
      }
    ).all.map(&:commonplace_account_id).uniq.count
  end

  def self.weekly_pctg_platform_visit_for_community(start, finish, community)
    StatsFormatter.percent((NetworkHealthStats.unique_visit_count_for_community(start, finish, community).to_f / NetworkHealthStats.users_for_community(finish, community).to_f))
  end

  def self.percent_growth_for_community(start, finish, community)
    StatsFormatter.percent((NetworkHealthStats.users_for_community(finish, community) - NetworkHealthStats.users_for_community(start, community)).to_f / (NetworkHealthStats.users_for_community(start, community) || 1).to_f)
  end

  def self.item_gains_per_day_for_community(start, finish, community, item, days_elapsed)
    StatsFormatter.decimal(NetworkHealthStats.new_items_for_community_in_date_range(start, finish, community, item).to_f / days_elapsed.to_f) # Translation: .to_f converts e.g. 1 -> 1.0
  end
end

class StatisticsNetworkHealthCsvGenerator
  @queue = :statistics

  def self.end_date
    @end_date ||= Date.today.to_datetime
  end

  def self.end_date=(new_date)
    @end_date = new_date
  end

  def self.start_date
    (end_date - days_elapsed.days).to_datetime
  end

  def self.start_date=(new_date)
    @start_date = new_date
  end

  def self.days_elapsed
    7
  end

  def self.frequency
    "weekly"
  end

  def self.filename
    "network_health_weekly.xlsx"
  end

  def self.copy_redis_values(original_redis, new_redis)
    keys = [
      "statistics:network_health_#{frequency}",
    ]
    keys.each do |redis_key|
      new_redis.set(redis_key, original_redis.get(redis_key))
    end
  end

  def self.perform(redis = Resque.redis)
    require 'simple_xlsx'

    original_start_date = start_date
    original_end_date = end_date

    str = ""
    io = StringIO.new(str)

    SimpleXlsx::Sheet.new(nil, "Network Health", io) do |sheet|
      sheet.add_row([
        "BY COMMUNITY",
        "Total Users",
        "% Growth",
        "User Gains / Day",
        "Posts / Day",
        "Events / Day",
        "Daily Bulletins Opened",
        "Weekly % Platform Visit"
      ])
      NetworkHealthStats::core_communities.each do |community|
        sheet.add_row([
          community.name,
          NetworkHealthStats.users_for_community(end_date, community),
          NetworkHealthStats.percent_growth_for_community(start_date, end_date, community),
          NetworkHealthStats.item_gains_per_day_for_community(start_date, end_date, community, User, days_elapsed),
          NetworkHealthStats.item_gains_per_day_for_community(start_date, end_date, community, Post, days_elapsed),
          NetworkHealthStats.item_gains_per_day_for_community(start_date, end_date, community, Event, days_elapsed),
          NetworkHealthStats.daily_bulletin_opens_for_community(start_date, end_date, community),
          NetworkHealthStats.weekly_pctg_platform_visit_for_community(start_date, end_date, community)
        ])
      end

      start_date = original_start_date - 4.weeks
      end_date = original_end_date - 4.weeks

      sheet.add_row([
        "BY WEEK",
        end_date.to_date.to_s,
        (end_date + 1.week).to_date.to_s,
        (end_date + 2.weeks).to_date.to_s,
        (end_date + 3.weeks).to_date.to_s,
        (end_date + 4.weeks).to_date.to_s
      ])

      sheet.add_row([
        "Total Users",
        User.core.up_to(end_date).count,
        User.core.up_to(end_date + 1.week).count,
        User.core.up_to(end_date + 2.weeks).count,
        User.core.up_to(end_date + 3.weeks).count,
        User.core.up_to(end_date + 4.weeks).count
      ])

      sheet.add_row([
        "% Network Growth",
        NetworkHealthStats.percent_growth(start_date, end_date),
        NetworkHealthStats.percent_growth(start_date + 1.week, end_date + 1.week),
        NetworkHealthStats.percent_growth(start_date + 2.weeks, end_date + 2.weeks),
        NetworkHealthStats.percent_growth(start_date + 3.weeks, end_date + 3.weeks),
        NetworkHealthStats.percent_growth(start_date + 4.weeks, end_date + 4.weeks)
      ])

      sheet.add_row([
        "User Gains / Day / Community",
        NetworkHealthStats.items_per_day_per_community(start_date, end_date, User),
        NetworkHealthStats.items_per_day_per_community(start_date + 1.week, end_date + 1.week, User),
        NetworkHealthStats.items_per_day_per_community(start_date + 2.weeks, end_date + 2.weeks, User),
        NetworkHealthStats.items_per_day_per_community(start_date + 3.weeks, end_date + 3.weeks, User),
        NetworkHealthStats.items_per_day_per_community(start_date + 4.weeks, end_date + 4.weeks, User)
      ])

      sheet.add_row([
        "Events / Day / Community",
        NetworkHealthStats.items_per_day_per_community(start_date, end_date, Event),
        NetworkHealthStats.items_per_day_per_community(start_date + 1.week, end_date + 1.week, Event),
        NetworkHealthStats.items_per_day_per_community(start_date + 2.weeks, end_date + 2.weeks, Event),
        NetworkHealthStats.items_per_day_per_community(start_date + 3.weeks, end_date + 3.weeks, Event),
        NetworkHealthStats.items_per_day_per_community(start_date + 4.weeks, end_date + 4.weeks, Event)
      ])

      sheet.add_row([
        "Posts / Day / Community",
        NetworkHealthStats.items_per_day_per_community(start_date, end_date, Post),
        NetworkHealthStats.items_per_day_per_community(start_date + 1.week, end_date + 1.week, Post),
        NetworkHealthStats.items_per_day_per_community(start_date + 2.weeks, end_date + 2.weeks, Post),
        NetworkHealthStats.items_per_day_per_community(start_date + 3.weeks, end_date + 3.weeks, Post),
        NetworkHealthStats.items_per_day_per_community(start_date + 4.weeks, end_date + 4.weeks, Post)
      ])

      # sheet.add_row([
        # "Daily Bulletin Open Rate",
        # NetworkHealthStats.daily_bulletin_open_rate(start_date, end_date),
        # NetworkHealthStats.daily_bulletin_open_rate(start_date + 1.week, end_date + 1.week),
        # NetworkHealthStats.daily_bulletin_open_rate(start_date + 2.weeks, end_date + 2.weeks),
        # NetworkHealthStats.daily_bulletin_open_rate(start_date + 3.weeks, end_date + 3.weeks),
        # NetworkHealthStats.daily_bulletin_open_rate(start_date + 4.weeks, end_date + 4.weeks)
      # ])

      # sheet.add_row([
        # "Weekly Platform Engagement",
        # NetworkHealthStats.platform_engagement(start_date, end_date),
        # NetworkHealthStats.platform_engagement(start_date + 1.week, end_date + 1.week),
        # NetworkHealthStats.platform_engagement(start_date + 2.weeks, end_date + 2.weeks),
        # NetworkHealthStats.platform_engagement(start_date + 3.weeks, end_date + 3.weeks),
        # NetworkHealthStats.platform_engagement(start_date + 4.weeks, end_date + 4.weeks)
      # ])
    end

    redis.set("statistics:network_health_#{frequency}", str)
  end
end
