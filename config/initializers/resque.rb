require 'resque'

require 'resque/failure/multiple'
require 'resque/failure/redis'

if Rails.env.production?
  Resque::Failure::Multiple.classes = [Resque::Failure::Redis]
  Resque::Failure.backend = Resque::Failure::Multiple
end

