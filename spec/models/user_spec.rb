require 'spec_helper'

describe User do
  before(:each) do
    mock_geocoder
    @user = Factory.build(:user)
  end

  it "should be valid given valid attributes" do
    @user.valid?.should be_true
  end

  it "should respond to avatar" do
    @user.should respond_to(:avatar)
  end

  it "should respond to skills" do
    @user.should respond_to(:skills) 
  end

  it "should respond to interests" do
    @user.should respond_to(:interests) 
  end

  it "should respond to stuffs" do
    @user.should respond_to(:skills) 
  end

  it "should have events" do
    @user.events.should be_an(Array)
  end

  it "should require a first name" do
    @user = Factory.build(:user, :first_name => nil)
    @user.valid?.should_not be_true
  end
  
  it "should require a last name" do
    @user = Factory.build(:user, :last_name => nil)
    @user.valid?.should_not be_true
  end

  it "should have a full_name" do
    @user.full_name.should be_a(String)
  end

  it "should require an email address" do
    @user.email = nil
    @user.valid?.should be_false
  end

end
