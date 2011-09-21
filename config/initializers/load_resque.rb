require 'resque'
require 'resque_scheduler'

uri = if Rails.env.development? || Rails.env.test?
        URI.parse("localhost:6379")
      elsif ENV["REDISTOGO_URL"].present?
        URI.parse(ENV["REDISTOGO_URL"])
      end

if uri
  Resque.redis = Redis.new(:host => uri.host, 
                           :port => uri.port, 
                           :password => uri.password, 
                           :thread_safe => true)

  Resque.schedule = 
    YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))

end
