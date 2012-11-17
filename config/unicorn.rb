worker_processes 1
timeout 30
preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  if defined?(Resque)
    Resque.redis.quit
    # TODO: Clean up the workers
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1 # Give the disconnectsion time to set
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info 'Connected to ActiveRecord'
  end

  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info 'Connected to Redis'
  end
end
