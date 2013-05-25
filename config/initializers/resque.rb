require 'resque'

require 'resque/failure/multiple'
require 'resque/failure/redis'

if Rails.env.production?

  Resque::Failure::Honeybadger.configure do |config|
    config.api_key = '***REMOVED***'
  end

  Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Honeybadger]
  Resque::Failure.backend = Resque::Failure::Multiple
end

