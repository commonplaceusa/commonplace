require 'spec_helper'

describe Met do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Met.create!(@valid_attributes)
  end
end
