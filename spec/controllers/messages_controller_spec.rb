require 'spec_helper'

describe MessagesController do

  describe "#create" do
    before :each do
      current_community
      @message = mock_model(Message)
      stub(current_user).messages.stub!.build { @message }
    end
    
    it "should try to create a message" do
      mock(@message).save
      post :create
    end
    
    context "on successful save" do
      before :each do 
        stub(@message).save { true }
        stub(@message).messagable.stub!.name { "Messagable Name" }
        stub(NotificationsMailer).deliver_message
        post :create
      end

      it "delivers a notification to the messagable" do
        NotificationsMailer.should have_received.deliver_message(@message.id) 
      end

      it "sets a flash.now message with the messagable's name" do
        response.flash[:message].should match("Messagable Name")
      end
    end
  end
  
end
