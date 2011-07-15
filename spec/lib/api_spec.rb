require 'spec_helper'
require 'rack/test'


set :environment, :test


describe API do 
  include Rack::Test::Methods
  include WebMock::API
  let(:app) { API }
  let(:community) { mock_model(Community) }
  shared_examples "A JSON endpoint" do
    it "returns a valid JSON response" do
      get uri
      lambda {JSON.parse(last_response.body)}.should_not raise_error(JSON::ParserError)
    end
  end
  
  before do 
    stub_request(:get, "http://maps.google.com/maps/api/geocode/json?address=100%20Endless%20Sidewalk&language=en&sensor=false").
      to_return(:body => %q[{"results" : [], "status" : "ZERO_RESULTS"}])
    stub(User).find_by_id { true }
    stub(Community).find(community.id.to_s) { community }
  end
  
  describe "GET /" do 
    it "returns HI!" do 
      get '/'
      last_response.should be_ok
      last_response.body.should == "HI!"
    end
  end
  
  describe "GET /communities/:id/posts" do
    
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/posts" }
    end
    
  end

  describe "GET /communities/:id/events" do
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/events" }
    end
  end
  
  describe "GET /communities/:id/events" do
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/events" }
    end
  end

  describe "GET /communities/:id/announcements" do
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/announcements" }
    end
  end

  describe "GET /communities/:id/group_posts" do
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/group_posts" }
    end
  end
  
end
