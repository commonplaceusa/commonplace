
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  
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
  
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].
    each {|f| require f}
   
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  
  RSpec.configure do |config|
    
    config.before(:each, :type => :controller) do
      stub(Community).find_by_slug { current_community }
    end
    
    config.mock_with :rr
    #config.include RSpec::Rails::Mocks
    
    config.use_transactional_fixtures = false
    config.use_instantiated_fixtures = false
  end
  
  # def current_user
  #   unless @current_user
  #     @current_user = mock_model(User)
  #     stub(UserSession).find.stub!.user { @current_user }
  #   end
  #   @current_user
  # end
  
  # def current_user_session
  #   @current_user_session ||= stub(UserSession.new).user { stub(current_user).role_symbols { [:user] } }
  # end
  
  # def current_community
  #   @current_community ||= s#mock_model(Community, :name => Forgery(:basic).text)
  # end
  
  # def login
  #   stub(UserSession).find { current_user_session }
  # end
  
  # def logout
  #   stub(current_user).role_symbols { [:guest] }
  #   stub(UserSession).find { current_user_session }
  # end

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

Spork.each_run do end
