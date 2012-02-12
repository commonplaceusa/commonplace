class StatisticsCsvGenerator
  # TODO: This should be independent of StatisticsAggregator
  #
  def self.perform(globally = true)
    Community.all.each do |c|
      Resque.redis.set("statistics:csv:#{c.slug}", nil)
      Resque.redis.set("statistics:hashed:#{c.slug}", nil)
    end
    Resque.redis.set("statistics:csv:global", nil) if globally
    Resque.redis.set("statistics:hashed:global", nil) if globally
    Resque.redis.set("statistics:csv:meta:date", Date.today.to_s)
    Resque.redis.set("statistics:hashed:meta:date", Date.today.to_s)
    Community.all.select { |c| c.core }.each do |c|
      StatisticsAggregator.generate_statistics_csv_for_community(c)
      StatisticsAggregator.generate_hashed_statistics_for_community(c)
    end
    StatisticsAggregator.csv_statistics_globally if globally
    StatisticsAggregator.generate_hashed_statistics_globally if globally
  end
end
