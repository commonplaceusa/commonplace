# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Deflater
require 'resque/server'
require 'resque-cleaner'

app = Rack::Builder.new do 

  if Rails.env.staging? || Rails.env.production?

    use Rack::Exceptional, ENV['exceptional_key']

    use Rack::Timeout
    Rack::Timeout.timeout = 15 # seconds

    #use(Rack::Cache,
    #    :verbose     => true,
    #    :metastore   => Dalli::Client.new,
    #    :entitystore => Dalli::Client.new)
  end

  map("/resque") { run Resque::Server }
  map("/") { run Commonplace::Application }
end

run app
