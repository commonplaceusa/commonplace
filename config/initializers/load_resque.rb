require 'resque'
require 'resque_scheduler'
# require 'resque-job-stats/server'

uri = URI.parse(ENV.fetch("OPENREDIS_URL", "localhost:6379"))

if uri.present?
  Resque.redis = Redis.new(:host => uri.host,
                           :port => uri.port,
                           :password => uri.password,
                           :thread_safe => true)
end

Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))
