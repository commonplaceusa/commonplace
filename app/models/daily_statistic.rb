class DailyStatistic
  def self.increment_or_create(key)
    KickOff.new.enqueue_statistic_increment(key)
  end

  def self.value(key, redis = Resque.redis, namespace = "statistics:daily")
    redis.get(namespace + ":" + key)
  end
end
