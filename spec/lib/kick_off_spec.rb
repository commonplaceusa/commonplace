require 'spec_helper'

describe KickOff do
  let(:queuer) { Object.new.tap {|o| stub(o).enqueue } }
  let(:kickoff) { KickOff.new(queuer) }
  
  before { stub(queuer).enqueue }

  subject { queuer }

  describe "#deliver_post" do
    let(:post) {
      Post.new.tap do |p|
        stub(p).id { 23 }
        stub(p).user_id { 5 }
        stub(p).neighborhood.stub!.users.
          stub!.receives_posts_live { 
          (1..5).map {|id| User.new {|u| u.id = id } } 
        }
      end
    }

    before { kickoff.deliver_post(post) }
    
    it "queues a PostNotification for users in the neighborhood who receive posts live" do
      (1..4).each do |id|
        should have_queued(PostNotification, post.id, id)
      end
    end

    it "doesn't queue a PostNotification for the poster" do
      should_not have_queued(PostNotification, post.id, 5)
    end

  end

  describe "#deliver_announcement" do 
    
    context "when owner isn't a Feed" do
      let(:post) {
        Announcement.new.tap do |a|
          stub(a).id { 24 }
          stub(a).owner { User.new }
        end
      }

      before { kickoff.deliver_announcement(post) }

      it "doesn't enqueue anything" do
        should_not have_queued
      end
    end
    
    context "when owner is a Feed" do
      let(:post) {
        owner = Feed.new
        stub(owner).live_subscribers { (1..5).map {|id| User.new {|u| u.id = id } } }
        Announcement.new.tap do |a|
          stub(a).id { 24 }
          stub(a).owner { owner }
        end
      }

      before { kickoff.deliver_announcement(post) }
      
      it "enqueues an AnnouncementNotification for each live subscriber" do
        (1..5).each do |id|
          should have_queued(AnnouncementNotification, post.id, id)
        end

      end
    end
  end

  describe "#deliver_reply" do
    let(:repliable) {
    }
    let(:reply) {
      repliable = Post.new
      stub(repliable).replies { [1,2,3,4,5,4,3].map {|id| Reply.new(:user_id => id) } }
      stub(repliable).user_id { 6 }

      Reply.new.tap do |r|
        stub(r).user_id { 5 }
        stub(r).id { 76 }
        stub(r).repliable { repliable }
      end
    }

    before { kickoff.deliver_reply(reply) }

    it "delivers a (single) ReplyNotification to the Post owner" do
      should have_queued(ReplyNotification, reply.id, reply.repliable.user_id).times(1)
    end

    it "delivers a (single) ReplyNotification to people who have replied" do
      [1,2,3,4,6].each do |id|
        should have_queued(ReplyNotification, reply.id, id).times(1)
      end
    end

    it "does not deliver to the poster" do 
      should_not have_queued(ReplyNotification, reply.id, reply.user_id)
    end
  end

  describe "#deliver_feed_invite" do
    let(:emails) { ["nonexistant@example.com", "existant@example.com"] }
    let(:feed) { Feed.new {|f| f.id = 1 } }

    before(:each) do
      stub(User).exists?(hash_including(:email => "nonexistant@example.com")) { false }
      stub(User).exists?(hash_including(:email => "existant@example.com")) { true }
      stub(queuer).enqueue
    end

    before { kickoff.deliver_feed_invite(emails, feed) }

    it "enqueues FeedInvitation for emails not already registered" do
      should have_queued(FeedInvitation, "nonexistant@example.com", feed.id)
    end

    it "does not enqueue a FeedInvitation for emails already registered" do
       should_not have_queued(FeedInvitation, "existant@example.com", feed.id)
    end

  end

  describe "#deliver_group_post" do 
    let(:post) {
      GroupPost.new.tap do |p|
        stub(p).user_id { 5 }
        stub(p).id { 3414 }
        stub(p).group.stub!.live_subscribers { 
          (1..5).map {|id| User.new {|u| u.id = id } }
        }        
      end
    }
    
    before { kickoff.deliver_group_post(post) }

    it "queues a GroupPostNotification subscribers of the group" do
      (1..4).each do |id| 
        should have_queued(GroupPostNotification, post.id, id)
      end
    end

    it "doesn't queue a GroupPostNotification for the poster" do
      should_not have_queued(GroupPostNotification, post.id, post.user_id)
    end
  end

  describe "#deliver_user_message" do
    let(:message) {
      Message.new.tap do |m|
        stub(m).id { 64 }
        stub(m).messagable_id { 12 }
      end
    }
    before { kickoff.deliver_user_message(message) }

    it "queues a MessageNotification job" do
      should have_queued(MessageNotification, 64, 12)
    end
  end

  describe "#deliver_post_to_community" do
    let(:post_neighborhood) {
      Neighborhood.new.tap do |n|
        stub(n).users.stub!.receives_posts_live { 
          (6..10).map {|id| User.new {|u| u.id = id } } 
        }
      end
    }
    let(:other_neighborhood) {
      Neighborhood.new.tap do |n|
        stub(n).users.stub!.receives_posts_live { 
          (1..5).map {|id| User.new {|u| u.id = id } } 
        }
      end
    }
    let(:community) {
      Community.new.tap do |c|
        stub(c).neighborhoods { [post_neighborhood, other_neighborhood] }
      end
    }
    let(:post) {
      Post.new.tap do |p|
        stub(p).community { community }
        stub(p).neighborhood { post_neighborhood }
        stub(p).id { 123 }
        stub(p).user_id { 6 }
      end
    }
    
    before { kickoff.deliver_post_to_community(post) }

    it "delivers to other neighborhoods in the community" do
      (1..5).each do |user_id|
        should have_queued(PostNotification, post.id, user_id)
      end
    end

    it "doesn't deliver to the post's neighborhood" do
      (7..10).each do |user_id|
        should_not have_queued(PostNotification, post.id, user_id)
      end
    end
  end

  describe "#deliver_clipboard_welcome" do
    let(:half_user) { HalfUser.new {|u| u.id = 12 } }
    before { kickoff.deliver_clipboard_welcome(half_user) }
    
    it "delivers a clipboard welcome" do
      should have_queued(ClipboardWelcome, half_user.id)
    end
    
  end

  describe "#deliver_user_invite" do
    let(:from_user) { User.new {|u| u.id = 12 } }
    let(:message) { "hello bob" }
    let(:email) { "bob@example.com" }
    before { kickoff.deliver_user_invite(email, from_user, message) }

    it "delivers a invite from the user to the email with message" do
      should have_queued(Invitation, email, from_user.id, message)
    end
  end

  describe "#deliver_post_confirmation" do
    let(:post) { Post.new {|p| p.id = 13 } }
    before { kickoff.deliver_post_confirmation(post) }

    it "delivers a PostConfirmation" do
      should have_queued(PostConfirmation, post.id)
    end
  end

  describe "#deliver_announcement_confirmation" do
    let(:post) { Announcement.new {|a| a.id = 13 } }
    before { kickoff.deliver_announcement_confirmation(post) }
      
    it "delivers an AnnouncementConfirmation" do
      should have_queued(AnnouncementConfirmation, post.id)
    end
  end

  describe "#deliver_feed_permission_warning" do
    let(:feed) { Feed.new {|f| f.id = 43 } }
    let(:user) { User.new {|u| u.id = 23 } }
    before { kickoff.deliver_feed_permission_warning(user, feed) }
    
    it "enqueues a NoFeedPermission job" do
      should have_queued(NoFeedPermission, user.id, feed.id)
    end
  end

  describe "#deliver_unknown_address_warning" do
    let(:user) { User.new {|u| u.id = 23 } }
    before { kickoff.deliver_unknown_address_warning(user) }

    it "enqueues an UnknownAddress job" do
      should have_queued(UnknownAddress, user.id)
    end
  end

  describe "#deliver_unknown_user_warning" do
    let(:email) { "test@example.com" }
    before { kickoff.deliver_unknown_user_warning(email) }
    
    it "enqueues an UnknownUser job" do
      should have_queued(UnknownUser, email)
    end
  end

  describe "#deliver_welcome_email" do
    let(:user) { User.new {|u| u.id = 23 } }
    before { kickoff.deliver_welcome_email(user) }

    it "enqueues an Welcome job" do
      should have_queued(Welcome, user.id)
    end

  end

  describe "#deliver_password_reset" do
    let(:user) { User.new {|u| u.id = 23 } }
    before { kickoff.deliver_password_reset(user) }

    it "enqueues an PasswordReset job" do
      should have_queued(PasswordReset, user.id)
    end
  end

  describe "#deliver_admin_question" do
    let(:from) { "asker@example.com" }
    let(:message) { "I have a question" }
    let(:name) { "Asker Jones" }
    before { kickoff.deliver_admin_question(from, message, name) }
    
    it "enqueues an AdminQuestion job" do
      should have_queued(AdminQuestion, from, message,name)
    end
  end

  describe "#deliver_daily_bulletin" do
    let(:community) { Community.new { |c|
      c.name = "Test"
      c.slug = "test"
    }}
    let(:user) { User.new {|u| 
      u.id = 23
      u.email = "test@ema.il"
      u.first_name = "John"
      u.community = community
    } }
    let(:date) { DateTime.now.utc }
    before { kickoff.deliver_daily_bulletin(user.email, user.first_name, user.community.name, user.community.locale, user.community.slug, date.to_s(:db), "posts", "announcements", "events") }
    
    it "enqueues a DailyBulletin job" do
      should have_queued(DailyBulletin, user.email, user.first_name, user.community.name, user.community.locale, user.community.slug, date.to_s(:db), "posts", "announcements", "events")
    end
  end

  describe "#deliver_feed_owner_welcome" do
    let(:feed) { Feed.new {|f| f.id = 34 } }
    before { kickoff.deliver_feed_owner_welcome(feed) }
    
    it "enqueues a welcome for the feed" do
      should have_queued(FeedWelcome, feed.id)
    end
  end
end
