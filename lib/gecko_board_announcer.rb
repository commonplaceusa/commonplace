class GeckoBoardAnnouncer
  @queue = :statistics

  def self.perform
    dashboard = Leftronic.new(ENV['LEFTRONIC_API_KEY'] || 'pjdDJRzToCFGERGfIGl5QuBTJRgEdYwG')
    dashboard.number("Users on Network", User.count)
    populations = []
    Community.find_each do |community|
      populations << { community.name => community.users.count }
    end
    dashboard.leaderboard("Users by Community", populations)
    dashboard.number("Daily Bulletins Sent Today", DailyStatistic.value("daily_bulletins_sent"))
    dashboard.number("Daily Bulletins Opened Today", DailyStatistic.value("daily_bulletins_opened"))
    dashboard.number("Daily Bulletin Open Rate Today", DailyStatistic.value("daily_bulletins_opened").to_f / DailyStatistic.value("daily_bulletins_sent").to_f)
    dashboard.number("Single Post Emails Sent Today", DailyStatistic.value("single_posts_sent"))
    dashboard.number("Single Post Emails Opened Today", DailyStatistic.value("single_posts_opened"))
    dashboard.number("Single Post Email Open Rate Today", DailyStatistic.value("single_posts_opened").to_f / DailyStatistic.value("single_posts_sent").to_f)
  end
end
