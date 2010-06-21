require 'spec_helper'

describe Conversation do
  before(:each) do
    @valid_attrs = Factory.attributes_for :conversation
  end

  it "should be valid given valid attrs" do
    Conversation.new(@valid_attrs).should be_valid
  end
end
