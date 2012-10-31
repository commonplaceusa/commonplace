class DailyStatistic
  REDIS_KEY_MIDNIGHT_CLEAR = "statistics:daily:CLEAR"

  def self.add_clear_key(key, redis = Resque.redis)
    clear_keys = redis.get(REDIS_KEY_MIDNIGHT_CLEAR)
    clear_keys << key
    redis.set(REDIS_KEY_MIDNIGHT_CLEAR, clear_keys.to_json)
  end
  def self.create(key, value, redis = Resque.redis, namespace = "statistics:daily")
    redis.set(namespace + ":" + key, value)
    add_clear_key(key)
  end

  def self.increment(key, value, redis = Resque.redis, namespace = "statistics:daily")
    redis.incr(namespace + ":" + key)
  end

  def self.increment_or_create(key, redis = Resque.redis, namespace = "statistics:daily")
    result = redis.get(namespace + ":" + key)
    if result.present?
      redis.incr(namespace + ":" + key)
    else
      redis.set(namespace + ":" + key, 0) unless result.present?
    end
    add_clear_key(key)
  end

  def self.clear(key, redis = Resque.redis, namespace = "statistics:daily")
    redis.set(namespace + ":" + key, 0)
  end

  def self.value(key, redis = Resque.redis, namespace = "statistics:daily")
    redis.get(namespace + ":" + key)
  end
end
