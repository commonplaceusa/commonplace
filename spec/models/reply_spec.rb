require 'spec_helper'

describe Reply do
  before(:each) do
    @reply = Factory.build(:reply)
  end

  it "should create a new instance given valid attributes" do
    @reply.valid?.should be_true
  end
end
