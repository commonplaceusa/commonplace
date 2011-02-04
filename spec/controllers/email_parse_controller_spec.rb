require 'spec_helper'

describe EmailParseController do
  
  let(:user) { mock_model(User, :email => "test@example.com") }
  let(:reply) { mock_model(Reply) }

  before :each do 
    stub(Reply).create { reply }
    stub(User).find_by_email(user.email) { user }
    @reply_text = "reply text"
  end

  describe "#messages" do
    let(:message) { mock_model(Message, :long_id => "abbacap") }

    before :each do 
      stub(Message).find_by_long_id(message.long_id) { message }
      stub(NotificationsMailer).deliver_message_reply
      post(:messages,
           :from => user.email,
           :to => "#{message.long_id}@messages.test.ourcommonplace.com",
           :text => @reply_text)
    end

    it "creates a reply to the message by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => message))
    end

    it "sends a message reply notification" do
      NotificationsMailer.should have_received.deliver_message_reply(reply.id)
    end

  end
 
  describe "#events" do
    let(:event) { mock_model(Event, :long_id => "abbacap") }

    before :each do 
      stub(Event).find_by_long_id(event.long_id) { event }
      stub(NotificationsMailer).deliver_event_reply
      post(:events,
           :from => user.email,
           :to => "#{event.long_id}@events.test.ourcommonplace.com",
           :text => @reply_text)
    end

    it "creates a reply to the event by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => event))
    end

    it "sends a event reply notification" do
      NotificationsMailer.should have_received.deliver_event_reply(reply.id)
    end

  end


  describe "#posts" do
    let(:test_post) { mock_model(Post, :long_id => "abbacap") }

    before :each do 
      stub(Post).find_by_long_id(test_post.long_id) { test_post }
      stub(NotificationsMailer).deliver_post_reply
      post(:posts,
           :from => user.email,
           :to => "#{test_post.long_id}@posts.test.ourcommonplace.com",
           :text => @reply_text)
    end

    it "creates a reply to the post by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => test_post))
    end

    it "sends a post reply notification" do
      NotificationsMailer.should have_received.deliver_post_reply(reply.id)
    end

  end


  describe "#announcements" do
    let(:announcement) { mock_model(Announcement, :long_id => "abbacap") }

    before :each do 
      stub(Announcement).find_by_long_id(announcement.long_id) { announcement }
      stub(NotificationsMailer).deliver_announcement_reply
      post(:announcements,
           :from => user.email,
           :to => "#{announcement.long_id}@announcements.test.ourcommonplace.com",
           :text => @reply_text)
    end

    it "creates a reply to the announcement by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => announcement))
    end

    it "sends a announcement reply notification" do
      NotificationsMailer.should have_received.deliver_announcement_reply(reply.id)
    end

  end

end
