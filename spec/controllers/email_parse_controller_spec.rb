require 'spec_helper'

describe EmailParseController do

  describe "POST parse" do
    before :each do 
      @post = mock()
      @user = mock()
      @text = "Lorem ipsum..."
      stub(Post).find(20) { @post }
      stub(Post).find_by_long_id("MjA1") { @post }
      stub(User).find_by_email("test@example.com") { @user }
      stub(Reply).create
    end

    it "should create a reply to a post when the email is to post-id@.*" do
      get :parse, :text => @text, :from => "test@example.com", :to => "MjA1@replies.commonplaceusa.com"
      Reply.should have_received.create(hash_including(:body => @text,
                                                       :user => @user,
                                                       :repliable => @post))
    end
  end
end
