require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do

  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
  ENV["RAILS_ENV"] ||= 'test'
  require 'spec'
  require 'spec/rails'
  require 'rr'  
  require 'spec/rr'
  Spec::Runner.configure do |config|
    config.mock_with RR::Adapters::Rspec
    config.use_transactional_fixtures = false
    config.use_instantiated_fixtures = false
  end
  
  def current_user
    unless @current_user
      @current_user = mock_model(User)
      stub(UserSession).find.stub!.user { @current_user }
    end
    @current_user
  end
  
  def current_user_session
    @current_user_session ||= stub(UserSession.new).user { stub(current_user).role_symbols { [:user] } }
  end
  
  def current_community
    unless @current_community
      @current_community = mock_model(Community)
      stub(Community).find_by_slug { @current_community }
    end
    @current_community
  end
  
  def login
    stub(UserSession).find { current_user_session }
  end
  
  def logout
    stub(current_user).role_symbols { [:guest] }
    stub(UserSession).find { current_user_session }
  end

  def mock_geocoder
    location = Object.new
    stub(location) do
      success? { true }
      lat { 100 }
      lng { 100 }
      full_address { "105 Winfield Way, Aptos, CA, 95003, USA" }
    end
    stub(Geokit::Geocoders::GoogleGeocoder).geocode { location }
  end
  
end

Spork.each_run do

  
end


