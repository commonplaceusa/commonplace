# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Commonplace::Application.initialize!

Commonplace::Application.configure do
  config.middleware.delete Rack::Timeout
end
