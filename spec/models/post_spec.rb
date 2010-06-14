require 'spec_helper'

describe Post do
  before(:each) do
    @post = Factory.build(:post)
  end

  it "should create a new instance given valid attributes" do
    @post.valid?.should be_true
  end
end
