require 'spec_helper'

describe User do

  before :each do
    @user = User.new
  end
  
  it "should require a community" do
    @user.valid?
    @user.should have_at_least(1).errors_on(:community)
  end

  it "should require an address on update" do
    stub(@user).new_record? { false }
    @user.valid?
    @user.should have_at_least(1).errors_on(:address)
  end

  it "should require an email" do
    @user.valid?
    @user.should have_at_least(1).errors_on(:email)
  end

  it "should require a first_name" do
    @user.valid?
    @user.should have_at_least(1).errors_on(:first_name)
  end

  it "should require a last_name" do
    @user.valid?
    @user.should have_at_least(1).errors_on(:first_name)
  end

  it "should add an error on full_name if not present" do
    @user.valid?
    @user.should have_at_least(1).errors_on(:full_name)
  end

  it "should have a full_name composed of it's first and last names" do
    @user.first_name = "Bob"
    @user.last_name = "Joe"
    @user.full_name.should == "Bob Joe"
  end

  it "should capitalize the first name and last name when set via full_name" do
    @user.full_name = "billy joel"
    @user.first_name.should == "Billy"
    @user.last_name.should == "Joel"
  end

  it "should handle first_name=(nil) gracefully" do
    @user.full_name = nil
    @user.first_name.should == ""
    @user.last_name.should == ""
  end

  it "should handle first_name=("") gracefully" do
    @user.full_name = ""
    @user.first_name.should == ""
    @user.last_name.should == ""
  end

  describe "without an associated facebook account" do
    
    it "should require an address on create" do 
      @user.valid?
      @user.should have_at_least(1).errors_on(:address)
    end

  end

  describe "with an associated facebook account" do
    before :each do
      stub(@user).authenticating_with_oauth2? { true }
      stub(@user).validate_by_oauth2
    end
    
    it "should not require an address on create" do
      @user.valid?
      @user.should have(0).errors_on(:address)
    end

    describe "before creation" do
      before :each do 
        stub(@user).oauth2_access.stub!.get("/me") do
          '{"name": "Max Planck", "id": 42, "email": "moogle@example.com"}'
        end
        @user.after_oauth2_authentication
      end
      
      it "should use facebook full_name" do
        @user.full_name.should == "Max Planck"
      end
      
      it "should use facebook_uid" do
        @user.facebook_uid.should == 42
      end
      
      it "should use facebook email" do
        @user.email.should == "moogle@example.com"
      end
    end
  end
end
