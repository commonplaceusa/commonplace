require 'spec_helper'

describe NotificationsMailer do

  describe "#message_reply" do
    let(:message_owner) do
      mock_model(User,
                 :email => Forgery(:internet).email_address,
                 :first_name => Forgery(:name).first_name,
                 :last_name => Forgery(:name).last_name,
                 :community => stub(current_community).slug { Forgery(:basic).text })
    end
    
    let(:message_recipient) do
      mock_model(User,
                 :email => Forgery(:internet).email_address,
                 :first_name => Forgery(:name).first_name,
                 :last_name => Forgery(:name).last_name)
    end
      
    let(:message) do
      mock_model(Message,
                 :user => message_owner,
                 :messagable => message_recipient)
    end
    
    let(:reply) { mock_model(Reply, :repliable => message) }
    
    before :each do 
      stub(Reply).find(reply.id) { reply }
    end

    context "when replying to your own message" do
      before :each do
        stub(reply).user { message_owner }
        @mail = NotificationsMailer.create_message_reply(reply.id)
      end

      it "sends to the message's recipient" do
        @mail.to.should include(message_recipient.email)
      end
    end

    context "when replying to someone else's message" do
      before :each do 
        stub(reply).user { message_recipient }
        @mail = NotificationsMailer.create_message_reply(reply.id)
      end

      it "sends to the message owner" do
        @mail.to.should include(message_owner.email)
      end
    end
  end
end
