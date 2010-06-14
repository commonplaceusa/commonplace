require 'spec_helper'

describe Attendance do
  before(:each) do
    @attendance = Factory.build(:attendance)
  end

  it "should create a new instance given valid attributes" do
    @attendance.valid?.should be_true
  end
end
