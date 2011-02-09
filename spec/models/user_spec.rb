require 'spec_helper'

describe User do

  before :each do
    @user = User.new
  end

  describe "#valid?" do

    it "requires a community" do
      @user.valid?
      @user.should have_at_least(1).errors_on(:community)
    end

    it "requires an email" do
      @user.valid?
      @user.should have_at_least(1).errors_on(:email)
    end
    
    it "requires a first_name" do
      @user.valid?
      @user.should have_at_least(1).errors_on(:first_name)
    end

    it "requires a last_name" do
      @user.valid?
      @user.should have_at_least(1).errors_on(:first_name)
    end

    it "adds an error on full_name" do
      @user.valid?
      @user.should have_at_least(1).errors_on(:full_name)
    end

    context "on update" do
      before(:each) { stub(@user).new_record? { false } }

      it "requires an address" do
        @user.valid?
        @user.should have_at_least(1).errors_on(:address)
      end

      context "without an associated facebook account" do
        it "requires a password" do
          @user.valid?
          @user.should have_at_least(1).errors_on(:password)
        end
      end

    end
    
    context "on create" do
      context "without an associated facebook account" do
        it "requires an address" do 
          @user.valid?
          @user.should have_at_least(1).errors_on(:address)
        end
      end
      
      context "with an associated facebook account" do
        it "does not require an address" do
          stub(@user).authenticating_with_oauth2? { true }
          stub(@user).validate_by_oauth2
          @user.valid?
          @user.should have(0).errors_on(:address)
        end
      end
    end
  end

  describe "#full_name" do
    it "is composed of first and last names" do
      @user.first_name = "Bob"
      @user.last_name = "Joe"
      @user.full_name.should == "Bob Joe"
    end

    it "capitalizes the first name and last name" do
      @user.full_name = "billy joel"
      @user.first_name.should == "Billy"
      @user.last_name.should == "Joel"
    end
    
    it "handles =(nil) gracefully" do
      @user.full_name = nil
      @user.first_name.should == ""
      @user.last_name.should == ""
    end
    
    it "handles =('') gracefully" do
      @user.full_name = ""
      @user.first_name.should == ""
      @user.last_name.should == ""
    end
  end

  describe "#after_oauth2_authentication" do
    before :each do 
      stub(@user).oauth2_access.stub!.get("/me") do
        '{"name": "Max Planck", "id": 42, "email": "moogle@example.com"}'
      end
      @user.after_oauth2_authentication
    end
    
    it "sets facebook full_name" do
      @user.full_name.should == "Max Planck"
    end
    
    it "sets facebook_uid" do
      @user.facebook_uid.should == 42
    end
    
    it "sets facebook email" do
      @user.email.should == "moogle@example.com"
    end
  end

  describe "#inbox" do
    let(:user) do
      User.new.tap do |u|
        u.received_messages << Array.new(3) { 
          mock_model(Message, :updated_at => rand(10).hours.ago)
        }
        u.messages << Array.new(3) { 
          mock_model(Message, :updated_at => rand(10).hours.ago)
        }
      end
    end

    it "includes received messages" do
      user.received_messages.each do |message|
        user.inbox.should include(message)
      end
    end
    
    it "includes sent messages" do
      user.messages.each do |message|
        user.inbox.should include(message)
      end
    end
    
    it "orders messages most recently updated first" do
      user.inbox.should == user.inbox.sort {|m,n| n.updated_at <=> m.updated_at }
    end

  end
end
