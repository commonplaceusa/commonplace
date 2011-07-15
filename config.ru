# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'
require 'exceptional'

app = Rack::Builder.new do 
  use Rack::Exceptional, ENV['exceptional_key']
  use(Rack::Cache,
      :verbose     => true,
      :metastore   => Dalli::Client.new,
      :entitystore => Dalli::Client.new)


  map("/api") { 
    use Rack::Session::Cookie, :secret => Commonplace::Application.config.secret_token, :key => "_commonplace_session"
    run API
  }

  map("/resque") { run Resque::Server }

  map("/") { run Commonplace::Application }
end       

run app
