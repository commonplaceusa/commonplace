class DailyStatisticClearer
  @queue = :statistics_cleansing

  def self.perform!(redis = Resque.redis)
    redis.keys(StatisticsIncrementor::NAMESPACE + "*").each do |key|
      redis.set(StatisticsIncrementor::NAMESPACE + key, 0)
    end
  end
end
