require 'spec_helper'

describe MessagesController do

  describe "#create" do
    
    before :each do
      current_user
      @message = mock_model(Message, 
                            :messagable => stub!.name { "Messagable Name" })
      stub(Message).new { @message }
    end
    
    context "on successful save" do
      
      before :each do
        stub(@message).save { true }
        post :create
      end
      
      it "sets a flash.now message with the messagable's name" do
        response.flash[:message].should match("Messagable Name")
      end
    end
  end
  
end
