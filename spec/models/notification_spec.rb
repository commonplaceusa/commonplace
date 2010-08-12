require 'spec_helper'

describe Notification do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Notification.create!(@valid_attributes)
  end
end
