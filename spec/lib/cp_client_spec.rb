require 'spec_helper'

include WebMock::API


describe CPClient do
  let(:api_host) { "http://cpclient.test" }
  
  let(:logger) { 
    Object.new.tap do |l|
      stub(l).error
      stub(l).info
      stub(l).warn
    end
  }

  let(:cp_client) { CPClient.new(:host => api_host, 
                                 :api_key => "abcdefg",
                                 :logger => logger) }

  def stub_api(method, uri)
    stub_request(method, api_host + uri)
  end

  def stub_api_get(uri)
    stub_api(:get, uri)
  end

  shared_examples "a community resource list" do
    it "falls back to an empty list on error" do
      stub_api_get(uri).to_return(:status => 500)
      should == []
      logger.should have_received.warn(is_a String)
    end
  end
  

  describe "#community_posts" do
    let(:uri) { "/communities/1/posts" }
    subject { cp_client.community_posts(1) }

    it "lists some of the community's posts" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      cp_client.community_posts(1).should == [{"title" => "foo"},{"title" => "bar"}]
    end

    it_behaves_like "a community resource list"
      
  end

  describe "#community_events" do
    let(:uri) { "/communities/1/events" }
    subject { cp_client.community_events(1) }

    it "lists some of the community's events" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      should == [{"title" => "foo"},{"title" => "bar"}]
    end

    it_behaves_like "a community resource list"
  end


  describe "#community_publicity" do
    let(:uri) { "/communities/1/announcements" }
    subject { cp_client.community_publicity(1) }

    it "lists some of the community's announcements" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      should == [{"title" => "foo"},{"title" => "bar"}]
    end

    it_behaves_like "a community resource list" 

  end

  describe "#community_group_posts" do
    let(:uri) { "/communities/1/group_posts" }
    subject { cp_client.community_group_posts(1) }

    it "lists some of the community's group posts" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      should == [{"title" => "foo"},{"title" => "bar"}]
    end

    it_behaves_like "a community resource list"
  end

  describe "#community_neighbors" do
    let(:uri) { "/communities/1/users" }
    subject { cp_client.community_neighbors(1) }

    it "lists the members of the community" do 
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"name": "John Jacobs"}]
      JSON
      should == [{"name" => "John Jacobs"}]
    end

    it_behaves_like "a community resource list"
    
  end

  describe "#community_feeds" do 
    let(:uri) { "/communities/1/feeds" }
    subject { cp_client.community_feeds(1) }

    it "lists the community's feeds" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"name": "Corner Shop"}]
      JSON
      cp_client.community_feeds(1).should == [{"name" => "Corner Shop"}]
    end

    it_behaves_like "a community resource list"
  end

  describe "#community_groups" do 
    let(:uri) { "/communities/1/groups" }
    subject { cp_client.community_groups(1) }

    it "lists the community's groups" do
      stub_api_get(uri).to_return(:body => <<-JSON)
        [{"name": "Gardeners"}]
      JSON
      should == [{"name" => "Gardeners"}]
    end

    it_behaves_like "a community resource list"
  end

  describe "#post_info" do
    it "retrieves the post's info" do
      stub_api_get("/posts/3").to_return(:body => %q[{"body":"The quick Fox"}])
      cp_client.post_info(3)["body"].should == "The quick Fox"
    end
  end

  describe "#user_info" do
    it "retrieves the user's info" do
      stub_api_get("/users/4").to_return(:body => %q[{"about":"I like icecream"}])
      cp_client.user_info(4)["about"].should == "I like icecream"
    end
  end
    
    
end
