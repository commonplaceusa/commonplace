require 'spec_helper'
require 'rack/test'


set :environment, :test

describe API do 
  include Rack::Test::Methods
  include WebMock::API

  let(:kickoff) { KickOff.new }
  let(:account) { User.new }

  let(:app) { 
    lambda do |env| 
      env['kickoff'] = kickoff
      API.call(env) 
    end
  }

  let(:community) { mock_model(Community) }

  shared_examples "A JSON endpoint" do
    it "returns a valid JSON response" do
      lambda {JSON.parse(last_response.body)}.should_not raise_error(JSON::ParserError)
    end
  end

  before do 
    stub(User).find_by_authentication_token { true }
    stub(Community).find(community.id.to_s) { community }
  end

  describe "GET /" do 
    it "fails" do
      get '/'
      last_response.should_not be_ok
    end
  end

  describe "GET /contacts/authorization_url/yahoo" do
    before do
      stub_request(:post, "https://api.login.yahoo.com/oauth/v2/get_request_token").
        to_return(:status => 200, :body => "AUTH_TOKEN")
    end
    it_behaves_like "A JSON endpoint" do
      let(:uri) { "/contacts/authorization_url/yahoo" }
    end

    it "receives a valid authentication url" do
      post "/contacts/authorization_url/yahoo", {:return_url => "ourcommonplace.com"}
      @json = JSON.parse last_response.body
      @json.should_not be_nil
      @json[:authentication_url].should_not be_nil
    end
  end

end
