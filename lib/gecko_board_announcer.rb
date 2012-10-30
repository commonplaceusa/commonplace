class GeckoBoardAnnouncer
  @queue = :statistics

  def self.perform
    Geckoboard::Push.api_key = ENV['GECKOBOARD_API_KEY'] || 'd21e93640c2aca0b69fa91bfb1993cd4'
    Geckoboard::Push.new("22547-a3e71fa4e832b239ca8872c3f2b0189c").number_and_secondary_value(User.count, User.count(:conditions => "created_at < '#{1.day.ago.to_s(:db)}'"))
    text = ""
    Community.find_each do |community|
      text << "#{community.name}: #{community.users.count}\n"
    end
  end
end
