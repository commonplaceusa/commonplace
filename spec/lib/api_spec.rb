require 'spec_helper'
require 'rack/test'


set :environment, :test

describe API do
  include Rack::Test::Methods
  # include WebMock::API

  let(:kickoff) { KickOff.new }
  let(:account) { User.new }

  let(:app) {
    lambda do |env|
      env['kickoff'] = kickoff
      API.call(env)
    end
  }

  let(:community) { double("Community", id: 1) }

  shared_examples "A JSON endpoint" do
    it "returns a valid JSON response" do
      lambda {JSON.parse(last_response.body)}.should_not raise_error
    end
  end

  before do
    allow(Community).to receive(:find).with(community.id.to_s).and_return(community)
    allow(User).to receive(:find_by_authentication_token).and_return(true)
  end

  describe "GET /" do
    it "fails" do
      get '/'
      last_response.should_not be_ok
    end
  end
end
