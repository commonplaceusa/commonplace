require 'spec_helper'

describe User do

  let(:user) { User.new }

  describe "#valid?" do
    
    before { user.valid? }

    subject { user }
    
    it { should have_at_least(1).errors_on(:community) }
    it { should have_at_least(1).errors_on(:email) }
    it { should have_at_least(1).errors_on(:first_name) }
    it { should have_at_least(1).errors_on(:first_name) }
    it { should have_at_least(1).errors_on(:full_name) }

    context "on update" do
      before { stub(user).new_record? { false } ; user.valid? }

      it { should have_at_least(1).errors_on(:address) }
    end
    
    context "on create" do
      before { stub(user).new_record? { true } ; user.valid? }

      it { should have_at_least(1).errors_on(:address) }
    end
  end

  describe "#full_name" do
    it "is composed of first and last names" do
      user.first_name = "Bob"
      user.last_name = "Joe"
      user.full_name.should == "Bob Joe"
    end

    it "is composed of first, middle and last names" do
      user.first_name = "Bob"
      user.middle_name = "Robert"
      user.last_name = "Joe"
      user.full_name.should == "Bob Robert Joe"
    end

    it "capitalizes the first name and last name" do
      user.full_name = "billy joel"
      user.first_name.should == "Billy"
      user.last_name.should == "Joel"
    end

    it "capitalizes first, middle and last names" do
      user.full_name = "jason ross berlinsky"
      user.first_name.should == "Jason"
      user.middle_name.should == "Ross"
      user.last_name.should == "Berlinsky"
    end

    it "successfully handles changing away from a middle-named name" do
      user.first_name = "Max"
      user.middle_name = "Forrest"
      user.last_name = "Tilford"
      user.full_name.should == "Max Forrest Tilford"

      user.full_name = "Billy Joel"
      user.first_name.should == "Billy"
      user.middle_name.should be_empty
      user.last_name.should == "Joel"
      user.full_name.should == "Billy Joel"
    end

    it "comprehensively handles a complex middle name" do
      user.full_name = "jason r w berlinsky"
      user.first_name.should == "Jason"
      user.last_name.should == "Berlinsky"
      user.middle_name.should == "R W"
    end
    
    it "handles =(nil) gracefully" do
      user.full_name = nil
      user.first_name.should == ""
      user.last_name.should == ""
    end
    
    it "handles =('') gracefully" do
      user.full_name = ""
      user.first_name.should == ""
      user.last_name.should == ""
    end
  end

  describe "#inbox" do
    let(:user) do
      u = User.new do |u|
        stub(u).received_messages = Array.new(3) { 
        mock_model(Message, :updated_at => rand(10).hours.ago)
        }
        stub(u).messages = Array.new(3) { 
          mock_model(Message, :updated_at => rand(10).hours.ago)
        }
      end
    end

    it "includes received messages" do
      user.inbox.should include(*user.received_messages)
    end
    
    it "includes sent messages" do
      user.inbox.should include(*user.messages)
    end
    
    it "orders messages most recently updated first" do
      user.inbox.should == user.inbox.sort {|m,n| n.updated_at <=> m.updated_at }
    end

  end

  describe "#send_reset_password_instructions" do
    let(:user) { User.new {|u| 
        u.kickoff = kickoff 
        stub(u).generate_reset_password_token! 
      } 
    }
    let(:kickoff) { 
      KickOff.new.tap {|k| 
        stub(k).deliver_password_reset 
      }
    }
    before { user.send_reset_password_instructions }
    
    it "regenerates reset_password_token" do
      user.should have_received.generate_reset_password_token!
    end

    it "sends a reset password email" do
      kickoff.should have_received.deliver_password_reset(user)
    end
  end

end
