require 'spec_helper'

describe Sponsorship do
  before(:each) do
    @sponsorship = Factory.build(:business_sponsorship)
  end

  it "should create a new instance given valid attributes" do
    @sponsorship.valid?.should be_true
  end
end
