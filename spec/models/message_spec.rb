require 'spec_helper'

describe Message do
  describe "#valid?" do
    before :each do 
      @message = Message.new
    end

    it "requires a subject" do
      @message.valid?
      @message.should have(1).errors_on(:subject)
    end
    
    it "requires a body" do
      @message.valid?
      @message.should have(1).errors_on(:body)
    end
    
    it "requires a user (owner)" do
      @message.valid?
      @message.should have(1).errors_on(:user)
    end
    
    it "requires a messagable" do
      @message.valid?
      @message.should have(1).errors_on(:messagable)
    end
  end

  describe "#most_recent_body" do
    let(:message) do
      mock_model(Message, :body => Forgery(:basic).text)
    end
    context "given a message with no replies" do
      it "returns the message body" do
        stub(message).replies { [] }
        message.most_recent_body.should == message.body
      end
    end

    context "given a message with replies" do
      it "returns the most recent reply's body" do
        replies = Array.new(3) { |i| mock_model(Reply, :body => "body #{i}")}
        stub(message).replies { replies }
        message.most_recent_body.should == replies.last.body
      end
    end
  end
end
