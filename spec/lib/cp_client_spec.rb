require 'spec_helper'

include WebMock::API


describe CPClient do
  let(:api_host) { "http://cpclient.test" }

  let(:cp_client) { CPClient.new(:host => api_host, 
                                 :api_key => "abcdefg") }

  def stub_api(method, uri)
    stub_request(method, api_host + uri)
  end
  

  describe "#community_posts" do
    it "lists some of the community's posts" do
      stub_api(:get,"/communities/1/posts").to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      cp_client.community_posts(1).should == [{"title" => "foo"},{"title" => "bar"}]
    end
  end

  describe "#community_events" do
    it "lists some of the community's events" do
      stub_api(:get,"/communities/1/events").to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      cp_client.community_events(1).should == [{"title" => "foo"},{"title" => "bar"}]
    end
  end


  describe "#community_publicity" do
    it "lists some of the community's announcements" do
      stub_api(:get,"/communities/1/announcements").to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      cp_client.community_publicity(1).should == [{"title" => "foo"},{"title" => "bar"}]
    end

  end

  describe "#community_group_posts" do
    it "lists some of the community's group posts" do
      stub_api(:get, "/communities/1/group_posts").to_return(:body => <<-JSON)
        [{"title":"foo"},{"title":"bar"}] 
      JSON
      cp_client.community_group_posts(1).should == [{"title" => "foo"},{"title" => "bar"}]
    end
  end

  describe "#community_neighbors" do
    it "lists the members of the community" do 
      stub_api(:get, "/communities/1/users").to_return(:body => <<-JSON)
        [{"name": "John Jacobs"}]
      JSON
      cp_client.community_neighbors(1).should == [{"name" => "John Jacobs"}]
    end
  end

  describe "#community_feeds" do 
    it "lists the community's feeds" do
      stub_api(:get, "/communities/1/feeds").to_return(:body => <<-JSON)
        [{"name": "Corner Shop"}]
      JSON
      cp_client.community_feeds(1).should == [{"name" => "Corner Shop"}]
    end
  end

  describe "#community_groups" do 
    it "lists the community's groups" do
      stub_api(:get, "/communities/1/groups").to_return(:body => <<-JSON)
        [{"name": "Gardeners"}]
      JSON
      cp_client.community_groups(1).should == [{"name" => "Gardeners"}]
    end
  end
end
