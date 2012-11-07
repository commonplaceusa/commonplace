class GeckoBoardAnnouncer
  @queue = :statistics

  def self.perform
    tz = "Eastern Time (US & Canada)"
    dashboard = Leftronic.new(ENV['LEFTRONIC_API_KEY'] || '')
    dashboard.text("Statistics Information", "Update Started", "Began updating at #{DateTime.now.in_time_zone(tz).to_s}")
    dashboard.number("Users on Network", User.count)
    growths = []
    populations = []
    growth_headers = ["Community", "Users", "Weekly Growth", "Penetration"]
    Community.find_each do |community|
      growth = (community.growth_percentage.round(2))
      growth = "DNE" if growth.infinite?
      penetration = community.penetration_percentage.round(2)
      # penetration = 0
      growths << [community.name, community.users.count, "#{growth}%", "#{penetration.to_s.gsub("-1.0", "0")}%"]
      populations << {
        community.name => community.users.count
      }
    end

    growths = growths.sort_by do |v|
      v[1]
    end.append(growth_headers).reverse
    dashboard.table("Growth by Community", growths)
    dashboard.pie("Population by Community", populations)

    penetrations = Community.all.map { |c| c.penetration_percentage(false) }.reject { |v| v < 0 }
    dashboard.number("Overall Penetration", 100 * penetrations.inject{ |sum, el| sum + el }.to_f / penetrations.size)

    growth_rates = Community.all.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
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

    dashboard.number("E-Mails in Queue", Resque.size("notifications"))

    dashboard.text("Statistics Information", "Update Finished", "Finished updating at #{DateTime.now.in_time_zone(tz).to_s}")

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
