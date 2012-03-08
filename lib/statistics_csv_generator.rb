class StatisticsCsvGenerator
  # TODO: This should be independent of StatisticsAggregator
  #
  @queue = :statistics

  def self.perform(days = 30, globally = true)
    Resque.redis.set("statistics:meta:available", false)
    Community.all.each do |c|
      Resque.redis.set("statistics:csv:#{c.slug}", nil)
      Resque.redis.set("statistics:hashed:#{c.slug}", nil)
    end
    Resque.redis.set("statistics:csv:global", nil) if globally
    Resque.redis.set("statistics:hashed:global", nil) if globally
    Resque.redis.set("statistics:csv:meta:date", Date.today.to_s)
    Resque.redis.set("statistics:hashed:meta:date", Date.today.to_s)
    Community.all.select { |c| c.core }.each do |c|
      StatisticsAggregator.generate_statistics_csv_for_community(c, days)
      StatisticsAggregator.generate_hashed_statistics_for_community(c)
    end
    StatisticsAggregator.csv_statistics_globally(days) if globally
    StatisticsAggregator.generate_hashed_statistics_globally if globally
    Resque.redis.set("statistics:meta:available", true)
  end
end
