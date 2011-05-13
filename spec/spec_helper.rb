
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'rr_patch'

  RSpec.configure do |config|
    DatabaseCleaner.strategy = :truncation

    config.use_transactional_fixtures = false

    config.around :each, :type => :request do |example|
      DatabaseCleaner.start
      example.run
      DatabaseCleaner.clean
    end
    
    config.mock_with :rr

    config.before :all do 
      stub(Geocoder).search
    end

  end

end

Spork.each_run do 

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  

end
