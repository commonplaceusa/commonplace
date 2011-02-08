require 'spec_helper'

describe MessagesHelper do
  let(:message) do
    mock_model(Message,
               :subject => Forgery(:basic).text,
               :body => Forgery(:basic).text)
  end

  describe "#other_participant" do
    let(:current_user) { mock_model(User) }
    let(:other_user) { mock_model(User) }
    
    before :each do 
      stub(helper).current_user { current_user }
    end
    
    context "given a message where the current_user is the messagable" do
      it "returns the message.messagable" do
        stub(message).messagable { current_user }
        stub(message).user { other_user }
        helper.other_participant(message).should be(other_user)
      end
    end

    context "given a message where the current_user is the sender" do
      it "returns the message.user" do
        stub(message).messagable { other_user }
        stub(message).user { current_user }
        helper.other_participant(message).should be(other_user)
      end
    end

  end
  

end
