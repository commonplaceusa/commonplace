require 'spec_helper'

describe Organization do
  before(:each) do
    @organization = Factory.build(:organization)
  end

  it "should create a new instance given valid attributes" do
    @organization.valid?.should be_true
  end
end
