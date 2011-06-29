require 'resque'
require 'resque-exceptional'

require 'resque/failure/multiple'
require 'resque/failure/redis'

Resque::Failure::Exceptional.configure do |config|
  config.api_key = '0556a141945715c3deb50a0288ec3bea5417f6bf'
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Exceptional]
Resque::Failure.backend = Resque::Failure::Multiple

