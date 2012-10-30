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
  end
end
