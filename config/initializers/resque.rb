require 'resque'
require 'resque-exceptional'

require 'resque/failure/multiple'
require 'resque/failure/redis'

require 'resque/plugins/resque_heroku_autoscaler'

Resque::Failure::Exceptional.configure do |config|
  config.api_key = '0556a141945715c3deb50a0288ec3bea5417f6bf'
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Exceptional]
Resque::Failure.backend = Resque::Failure::Multiple




Resque::Plugins::HerokuAutoscaler.config do |c|
  c.new_worker_count do |pending|
    [(pending/5).ceil.to_i, 10].min
  end

  c.scaling_disabled = true if Rails.env.development? || Rails.env.test?
end
  
