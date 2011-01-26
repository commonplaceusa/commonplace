require 'spec_helper'

describe EmailParseController do

  describe "POST parse" do
    before :each do 
      @post = mock()
      @message = mock()
      @event = mock()
      @announcement = mock()
      @user = mock()
      @text = "Lorem ipsum..."
      stub(Post).find(20) { @post }
      stub(Post).find_by_long_id("MjA1") { @post }
      stub(Message).find(20) { @message }
      stub(Message).find_by_long_id("MjA1") { @message }
      stub(Event).find(20) { @event }
      stub(Event).find_by_long_id("MjA1") { @event }
      stub(Announcement).find(20) { @announcement }
      stub(Announcement).find_by_long_id("MjA1") { @announcement }
      stub(User).find_by_email("test@example.com") { @user }
      stub(Reply).create
    end

    it "should create a reply to a post when the email is to post-id@.*" do
      get :posts, :text => @text, :from => "test@example.com", :to => "MjA1@posts.test.commonplaceusa.com"
      Reply.should have_received.create(hash_including(:body => @text,
                                                       :user => @user,
                                                       :repliable => @post))
    end
 #   it "should create a reply to a post when the email is to message-id@.*" do
 #     get :posts, :text => @text, :from => "test@example.com", :to => "MjA1@messages.test.commonplaceusa.com"
 #     Reply.should have_received.create(hash_including(:body => @text,
 #                                                      :user => @user,
 #                                                      :repliable => @message))
 #   end
    it "should create a reply to a post when the email is to event-id@.*" do
      get :events, :text => @text, :from => "test@example.com", :to => "MjA1@events.test.commonplaceusa.com"
      Reply.should have_received.create(hash_including(:body => @text,
                                                       :user => @user,
                                                       :repliable => @event))
    end
    it "should create a reply to a post when the email is to announcement-id@.*" do
      get :announcements, :text => @text, :from => "test@example.com", :to => "MjA1@announcements.test.commonplaceusa.com"
      Reply.should have_received.create(hash_including(:body => @text,
                                                       :user => @user,
                                                       :repliable => @announcement))
    end
  end
end
