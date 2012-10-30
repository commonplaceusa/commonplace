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
    # dashboard.number("Users on Network in #{community.name}", community.users.count)
    dashboard.number("Daily Bulletins Sent Today", DailyStatistic.value("daily_bulletins_sent"))
    dashboard.number("Single Post Emails Sent Today", DailyStatistic.value("single_posts_sent"))
    dashboard.number("Daily Bulletins Opened Today", DailyStatistic.value("daily_bulletins_opened"))
    dashboard.number("Single Post Emails Opened Today", DailyStatistic.value("single_posts_opened"))
  end
end
