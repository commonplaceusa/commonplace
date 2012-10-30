class DailyStatisticClearer
  @queue = :statistics

  def self.perform!(redis = Resque.redis)
    keys = JSON.parse redis.get(DailyStatistic::REDIS_KEY_MIDNIGHT_CLEAR)
    keys.each do |key|
      DailyStatistic.clear(key)
    end
  end
end
