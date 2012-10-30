class GeckoBoardAnnouncer
  @queue = :statistics

  def self.perform
    Geckoboard::Push.api_key = ENV['GECKOBOARD_API_KEY'] || 'd21e93640c2aca0b69fa91bfb1993cd4'
    Geckoboard::Push.new("22547-a3e71fa4e832b239ca8872c3f2b0189c").number_and_secondary_value(User.count, User.count(:conditions => "created_at < '#{1.day.ago.to_s(:db)}'"))
    Community.find_each do |community|
      Geckoboard::Push.new(community.geckoboard_population_chart_id).number_and_secondary_value(community.users.count, community.users.count(:conditions => "created_at < '#{1.day.ago.to_s(:db)}'")) if community.try(:geckoboard_population_chart_id)
    end
    communities = []
    Community.all.sort_by { |c| c.users.count }.last(8).each do |community|
      communities << {
        value: community.users.count,
        label: community.name
      }
    end
    Geckoboard::Push.new('22547-80690bb44b5dffef99c9d7b3a3138d9f').funnel(communities.reverse, false, true)
  end
end
