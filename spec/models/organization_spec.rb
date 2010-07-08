require 'spec_helper'

describe Organization do
  before(:each) do
    @organization = Factory.build(:organization)
  end

  it "should create a new instance given valid attributes" do
    @organization.valid?.should be_true
  end


  it "should relate to text modules" do
    Organization.reflect_on_association(:text_modules).should_not be_nil
  end

  it "should relate to events" do
    Organization.reflect_on_association(:events).should_not be_nil
  end
  
  it "should relate to announcements" do
    Organization.reflect_on_association(:announcements).should_not be_nil
  end
end
