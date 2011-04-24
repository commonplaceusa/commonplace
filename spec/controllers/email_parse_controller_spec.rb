require 'spec_helper'

describe EmailParseController do

  describe ".strip_email_body" do
    after = "\n> > Hi Peter, 
> CommonPlace Team just replied to a message: jojo > > jojo > But laso check this out. "
    ["^-- \n", "^--\n", "-----Original\ Message-----", "--- Original Message---", "_" * 32, "On Mar 5, 2011, at 10:51 AM, Falls Church CommonPlace wrote:", "From: Max Tilford", "Sent from my iPhone", "4/10/2011 3:16:02 P.M. Eastern Daylight Time,\n nnotifications@fallschurch.ourcommonplace.com writes:"].each do |separator|

      it "strips by #{separator.chomp}" do
        result = EmailParseController.strip_email_body("
Hey -- testing a reply!
#{separator}
> > > Reply to CommonPlace 
> or reply to this email to message CommonPlace. > > Want to disable this and/or other e-mails? Click here to manage your subscriptions
")
        result.should match "Hey -- testing a reply"
        result.should_not match "Hi Peter"
      end
    end
  end

  let(:community) { mock_model(Community, :id => 1, :slug => "test") }
  let(:user) { mock_model(User, :email => "test@example.com", :community => community, :neighborhood => neighborhood) }

  let (:neighborhood) { mock_model(Neighborhood) }

  before :each do 
    stub(User).find_by_email(user.email) { user }
  end


  describe "repliable_id@replies.ourcommonplace.com" do
    let(:fake_post) { mock_model(Post) }
    let(:reply) { mock_model(Reply) }
    before :each do 
      @reply_text = "reply text"
      stub(Reply).create { reply }
      repliable_id = [fake_post.class.name.underscore, fake_post.id.to_s].join("_")
      stub(Repliable).find(repliable_id) { fake_post }
      post(:parse,
           :from => user.email,
           :to => "reply+#{repliable_id}@ourcommonplace.com",
           :text => @reply_text,
           :envelope => {:from => "test@example.com"})
    end

    it "creates a reply to the post by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => fake_post))
    end

  end
  
  describe "myneighbors@ourcommonplace.com" do

    let(:new_post) { mock_model(Post) } 
    before :each do
      stub(Post).create { new_post }
      @body = "Lorem Ipsum dolor sit amet."
      post(:parse,
           :from => user.email,
           :to => "neighborhood@ourcommonplace.com",
           :text => @body,
           :subject => @body,
           :envelope => {:from => "test@example.com"})
    end
    
    it "creates a new post" do
      Post.should have_received.create(hash_including(:user => user))
    end

  end
  
  describe "feed_slug@feeds.ourcommonplace.com" do
    let(:new_announcement) { mock_model(Announcement) }
    let(:feed) { mock_model(Feed, :slug => "test", :user_id => user.id, :community_id => community.id) }
    before :each do
      stub(Announcement).create { new_announcement }
      stub(Feed).find_by_slug( feed.slug ) { feed }
      @body = "Lorem Ipsum dolor sit amet."
      post(:parse,
           :to => "#{feed.slug}@ourcommonplace.com",
           :from => user.email,
           :text => @body,
           :subject => @body,
           :envelope => { :from => "test@example.com"})
    end
    
    it "posts a new announcement to a feed" do
      Announcement.should have_received.create(hash_including(:owner => feed))
    end
  end

  describe "autoresponder" do
    let(:new_announcement) { mock_model(Announcement) }
    let(:feed) { mock_model(Feed, :slug => "test", :user_id => user.id, :community_id => community.id) }
    before :each do
      stub(Announcement).create { new_announcement }
      stub(Feed).find_by_slug( feed.slug ) { feed }
      @body = "Lorem Ipsum dolor sit amet."
      post(:parse,
          :to => "#{feed.slug}@ourcommonplace.com",
          :from => user.email,
          :text => @body,
          :subject => @body,
          :envelope => {})
    end

    it "rejects a message without an envelope" do
      Announcement.should have_not_received.create(hash_including(:owner => feed))
    end
  end
  
end
