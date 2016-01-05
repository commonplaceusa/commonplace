require File.expand_path("../../config/environment", __FILE__)
# require 'rspec/rails'
require 'rspec/rails'
require 'capybara/rspec'
require "capybara-screenshot/rspec"
require "database_cleaner"
require "resque_spec"

include Capybara::DSL

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/acceptance/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Features, type: :feature
  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
