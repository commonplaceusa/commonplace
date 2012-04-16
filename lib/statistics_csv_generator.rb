class StatisticsCsvGenerator
  # TODO: This should be independent of StatisticsAggregator
  #
  @queue = :statistics

  def self.perform
    # Spin up EC2 instance
    #   The instance should run the remote connection on spin-up
    #   And should shut itself down automatically
    ec2 = AWS::EC2::Base.new(:access_key_id => ENV['EC2_KEY_ID'], :secret_access_key => ENV['EC2_KEY_SECRET'])
    ec2.start_instances({
      :instance_id => [ENV['EC2_STATS_CRUNCHER_INSTANCE_ID']]
    })
  end

  def self.run(days = 30, globally = true, redis = Resque.redis)
    redis.set("statistics:meta:available", false)
    Community.all.each do |c|
      redis.set("statistics:csv:#{c.slug}", nil)
      redis.set("statistics:hashed:#{c.slug}", nil)
    end
    redis.set("statistics:csv:global", nil) if globally
    redis.set("statistics:hashed:global", nil) if globally
    redis.set("statistics:meta:version", "#{DateTime.now.to_s(:number)}#{(Rails.env || ENV['RAILS_ENV'])[0]}")
    Community.where("core = true").each do |c|
      StatisticsAggregator.generate_statistics_csv_for_community(c, days, redis)
      StatisticsAggregator.generate_hashed_statistics_for_community(c, redis)
    end
    StatisticsAggregator.csv_statistics_globally(days, redis) if globally
    StatisticsAggregator.generate_hashed_statistics_globally(redis) if globally
    redis.set("statistics:meta:available", true)
  end

  def self.copy_redis_values(original_redis, new_redis)
    keys = [
            "statistics:csv:global",
            "statistics:hashed:global",
            "statistics:meta:version",
            "statistics:meta:available"
    ]
    Community.where("core = true").each do |c|
      keys.prepend "statistcs:csv:#{c.slug}"
      keys.prepend "statistics:hashed:#{c.slug}"
    end
    keys.each do |redis_key|
      new_redis.set(redis_key, original_redis.get(redis_key))
    end
  end

  def self.extract_csv_from_hash_for_community(c, redis = Resque.redis)
    array = redis.get("statistics:hashed:#{c.slug}")
    headers = array[0].keys.join ","
    data = [headers]
    array.each do |hash|
      data << (hash.values.map { |value| escape value unless value.nil? }.join ",")
    end
    data
  end

  def self.escape(string)
    string.gsub(",", '\,')
  end
end
