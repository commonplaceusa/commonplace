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

  describe "GET /communities/:id/addresses" do

    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/communities/#{community.id}/addresses" }
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

  describe "GET /users/:id" do

    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/users/:id" }
    end

    describe "response body" do
      let(:user) { mock_model(User, :facebook_uid => 2, :first_name => "John", :last_name => "Jacob", :middle_name => "Jingle", :about => "", :interest_list => "", :offer_list => "") }
      before do 
        stub(User).find(user.id.to_s) { user }
        get "/users/#{user.id}"
        @json = JSON.parse last_response.body
      end
      
      ["interests", "name", "avatar_url", "subscriptions", 
       "offers", "url", "id", "about", "last_name", 
       "first_name"].each do |key|
        it("has a(n) #{key} attribute") { @json.should have_key(key) }
      end
    end
  end

  describe "GET /posts/:id" do
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/users/:id" }
    end

    describe "response body" do
      let(:post) { mock_model(Post, :created_at => DateTime.now, :last_activity => DateTime.now) }
      let(:user) { mock_model(User, :facebook_uid => 2, :first_name => "John", :last_name => "Jacob", :middle_name => "Jingle", :about => "", :interest_list => "", :offer_list => "") }
      let(:json) do 
        stub(Post).find(post.id.to_s) { post }
        stub(post).user { user }
        get "/posts/#{post.id}"
        JSON.parse last_response.body
      end
      
      ["avatar_url", "last_activity", "body", "author", 
       "title", "url", "id", "published_at", "author_url", 
       "replies"].each do |key|
        it("has a(n) #{key} attribute") { json.should have_key(key) }
      end
    end
  end
end
