require 'spec_helper'

describe Message do
  describe "#valid?" do
    it "requires certain fields" do
      message = Message.new

      message.valid?

      expect(message.errors.keys).to include :subject
      expect(message.errors.keys).to include :body
      expect(message.errors.keys).to include :user
      expect(message.errors.keys).to include :messagable
    end
  end

  describe "#most_recent_body" do
    context "given a message with no replies" do
      it "is the message body" do
        message = Message.new
        allow(message).to receive(:body).and_return(Forgery(:basic).text)
        allow(message).to receive(:replies).and_return([])

        expect(message.most_recent_body).to eq message.body
      end
    end

    context "given a message with replies" do
      it "is the most recent reply" do
        message = Message.new
        allow(message).to receive(:body).and_return(Forgery(:basic).text)
        replies = Array.new(3) do |i|
          double(
            "Reply",
            body: "Body #{i}",
          )
        end
        allow(message).to receive(:replies).and_return(replies)

        expect(message.most_recent_body).to eq message.replies.last.body
      end
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
