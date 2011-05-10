
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  
  module RSpec::Rails::Mocks 
    
    module NullObject
      include ::RR::Space::Reader
      
      def method_missing(method_name, *args, &block)
        space.record_call(self, method_name, args, block)
        nil
      end
    end
    
    # Creates a mock object instance for a +model_class+ with common
    # methods stubbed out. Additional methods may be easily stubbed (via
    # add_stubs) if +stubs+ is passed.
    def mock_model(model_class, options_and_stubs = {})
      @options = parse_options(options_and_stubs)
      
    m = model_class.new
      id = next_id
      
      # our equivalent to Rspecs :errors => ''# stub("errors", :count => 0)
      stub(errors_stub = Object.new).count{0}

    options_and_stubs.reverse_merge!(
      :id => id,
      :to_param => "#{id}",
      :new_record? => false,
      :errors => errors_stub
    )

    m.extend NullObject if null_object?

    options_and_stubs.each do |method,value|
      stub(m).__send__(method) { value }
    end

    yield m if block_given?
    m
  end

  def stub_model(model_class, stubs={})
    stubs = {:id => next_id}.merge(stubs)
    @options = parse_options(stubs)
    
    returning model_class.new do |model|
      model.extend NullObject if null_object?
            
      model.id = stubs.delete(:id)
      model.extend Spec::Rails::Mocks::ModelStubber
      stubs.each do |k,v|
        if model.has_attribute?(k)
          model[k] = stubs.delete(k)
        end
      end
      stubs.each do |k,v|
        stub(model).__send__(k) { v }
      end
      yield model if block_given?
    end
  end

  private
  def parse_options(options)
    options.has_key?(:null_object) ? {:null_object => options.delete(:null_object)} : {}
  end
  
  def null_object?
    @options[:null_object]
  end
  
end

  module RR
    module Adapters
      module RSpec2
        include RRMethods
         
        def setup_mocks_for_rspec
          RR.reset
        end

        def verify_mocks_for_rspec
          RR.verify
        end
        def teardown_mocks_for_rspec
          RR.reset
        end

        def have_received(method = nil)
          RR::Adapters::Rspec::InvocationMatcher.new(method)
        end
        
      end
    end
  end
  
   RSpec.configuration.backtrace_clean_patterns.push(RR::Errors::BACKTRACE_IDENTIFIER)
  
  module RSpec
    module Core
      module MockFrameworkAdapter
         include RR::Adapters::RSpec2
      end
    end
  end
  
  
  RSpec.configure do |config|
    
    config.before(:each, :type => :controller) do
      stub(Community).find_by_slug { current_community }
    end
    DatabaseCleaner.strategy = :truncation
    config.use_transactional_fixtures = false

    config.around :each, :type => :request do |example|
      DatabaseCleaner.start
      example.run
      DatabaseCleaner.clean
    end
    
    config.mock_with :rr
    


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

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  

end
