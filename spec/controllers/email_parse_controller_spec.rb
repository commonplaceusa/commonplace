require 'spec_helper'

describe EmailParseController do

  describe "POST parse" do
    before :each do 
      @post = mock()
      puts @post.inspect
      @user = mock()
      @text = "Lorem ipsum..."
      stub(Post).find(20) { @post }
      stub(User).find_by_email("test@example.com") { @user }
      stub(Reply).create
    end

    #it "should be able to find the user"
    #  User.find_by_email("test@example.com").email.should match "test@example.com"
    #end
    
    it "should return the same text, since nothing is in the reply section" do
      EmailParseController.strip(@text,"post-20-reply@commonplaceusa.com").should == @text
    end

    it "should create a reply to a post when the email is to post-id@.*" do
      get :parse, :text => @text, :from => "test@example.com", :to => "post-20-reply@commonplaceusa.com"
      Reply.should have_received.create(hash_including(:body => @text,
                                                       :user => @user,
                                                       :repliable => @post))
    end
  end
end
