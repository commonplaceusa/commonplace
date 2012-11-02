class StatisticsIncrementor
  @queue = :ephemeral_statistics

  NAMESPACE = "statistics:daily:"

  def self.perform(key)
    result = Resque.redis.get(NAMESPACE + key)
    if result.present?
      Resque.redis.incr(NAMESPACE + key)
    else
      Resque.redis.set(NAMESPACE + key, 0)
    end
  end
end
