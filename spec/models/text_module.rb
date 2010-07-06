require 'spec_helper'

describe TextModule do
  before :each do
    @valid_attrs = Factory.attributes_for(:text_module)
    @valid_attrs[:group] = Factory(:organization)
  end

  it "should be valid given valid attributes" do
    TextModule.new(@valid_attrs).should be_valid
  end

  it "should require a title" do
    TextModule.new(@valid_attrs.except(:title)).should_not be_valid
  end

  it "should require a body" do
    TextModule.new(@valid_attrs.except(:body)).should_not be_valid
  end

  it "should be associated with an organization" do
    TextModule.reflect_on_association(:group).should_not be_nil
  end
end

