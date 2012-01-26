class StatisticsCsvGenerator
  # TODO: This should be independent of StatisticsAggregator
  #
  def self.perform
    Community.all.each do |c|
      Resque.redis.set("statistics:csv:#{c.slug}", nil)
    end
    Resque.redis.set("statistics:csv:meta:date", Date.today.to_s)
    Community.all.each do |c|
      StatisticsAggregator.generate_statistics_csv_for_community(c)
    end
  end
end
