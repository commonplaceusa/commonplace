require 'spec_helper'

describe Post do
  before(:each) do
    mock_geocoder
    @post = Factory.build(:post)
  end

  it "should be valid given valid attributes" do
    @post.valid?.should be_true
  end

  it "should require a user" do
    @post.user = nil
    @post.should_not be_valid
  end

  it "should require a body" do
    @post.body = nil
    @post.should_not be_valid
  end

  it "should have replies" do
    @post.replies.should be_an(Array)
  end    
end
