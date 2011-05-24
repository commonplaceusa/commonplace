# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require ::File.expand_path('../api',  __FILE__)


app = Rack::Builder.new do 
  map("/api") { 
    use Rack::Session::Cookie, :secret => Commonplace::Application.config.secret_token, :key => "_commonplace_session"
    run API
  }
  map("/") { run Commonplace::Application }
end       

run app
