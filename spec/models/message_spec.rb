require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attrs = Factory.attributes_for :message
    @valid_attrs[:user] = Factory :user
    @valid_attrs[:conversation] = Factory :conversation
  end

  it "should be valid given valid attrs" do
    Message.new(@valid_attrs).should be_valid
  end
end
