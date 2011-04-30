require 'spec_helper'

describe MessagesController do

  describe "#create" do
    
    before :each do
      stub(Community).find_by_slug { mock_model(Community, :name => "test") }
      stub(UserSession).find.stub!.user { mock_model(User, :admin? => false) }
      @message = mock_model(Message, 
                            :messagable => stub!.name { "Messagable Name" })
      stub(Message).new { @message }
    end
    
    context "on successful save" do
      
      before :each do
        stub(@message).save { true }
      end
      
      it "sets a flash.now message with the messagable's name" do
        post :create
        response.flash[:message].should match("Messagable Name")
      end
    end
  end
  
end
