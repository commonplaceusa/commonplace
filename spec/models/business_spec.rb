require 'spec_helper'

describe Business do
  before(:each) do
    @business = Factory.build(:business)
  end

  it "should create a new instance given valid attributes" do
    @business.valid?.should be_true
  end
end
