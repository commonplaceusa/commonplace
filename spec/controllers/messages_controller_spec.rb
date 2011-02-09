require 'spec_helper'

describe MessagesController do

  describe "#create" do
    
    before :each do
      current_user
      @message = mock_model(Message, 
                            :messagable => stub!.name { "Messagable Name" })
      stub(NotificationsMailer).deliver_message
      stub(Message).new { @message }
    end
    
    context "on successful save" do
      
      before :each do
        stub(@message).save { true }
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
