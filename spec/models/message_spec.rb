require 'spec_helper'

describe Message do
  describe "#valid?" do
    subject { Message.new }
    before { subject.valid? }

    it { should have(1).errors_on(:subject) }
    it { should have(1).errors_on(:body) }
    it { should have(1).errors_on(:user) }
    it { should have(1).errors_on(:messagable) }
  end

  describe "#most_recent_body" do
    let(:message) { mock_model(Message, :body => Forgery(:basic).text) }

    context "given a message with no replies" do
      before { stub(message).replies { [] } }      

      subject { message.most_recent_body }

      it { should == message.body }
    end

    context "given a message with replies" do
      let(:replies) { Array.new(3) { |i| mock_model(Reply, :body => "body #{i}")} }
      
      subject { message.most_recent_body }

      before { stub(message).replies { replies } }

      it { should == replies.last.body }
    end
  end

  describe "a user's inbox" do
    context "given the user sent the message" do
      let(:user) { User.new }
      let(:replier) { User.new }
      let(:message) { mock_model(Message, :body => Forgery(:basic).text, :user_id => user.id) }
      context "the message has not been replied to" do
        it "should have no messages in the inbox" do
          user.inbox.count { should == 0 }
        end
      end
      context "the message has been replied to" do
        let(:message) { mock_model(Message, :body => Forgery(:basic).text, :user_id => user.id, :replies_count => 1)}
        it "should have one message in the inbox" do
          # TODO: Implement. The issue is that we're basically mocking the DB.
        end
      end
    end
  end
end
