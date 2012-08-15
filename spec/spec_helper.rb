
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'rr_patch'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("spec/acceptance/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.use_transactional_examples = false

    config.mock_with :rr

    config.before :all do
      stub(Geocoder).search
    end

    config.before :suite do
      DatabaseCleaner.strategy = :transaction
      # DatabaseCleaner.clean_with(:truncation)
    end

    config.before :each do
      DatabaseCleaner.start
    end

    config.after :each do
      DatabaseCleaner.clean
    end

    config.include Matchers
    config.include Helpers, :type => :request
  end

end

Spork.each_run { }
