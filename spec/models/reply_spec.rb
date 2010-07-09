require 'spec_helper'

describe Reply do
  before(:each) do
    mock_geocoder
    @reply = Factory.build(:reply)
  end

  it "should be_valid given valid attributes" do
    @reply.should be_valid
  end

  context "should require a " do
    after(:each) do
      @reply.should_not be_valid
    end
    
    specify "post" do
      @reply.post = nil
    end

    specify "user" do
      @reply.user = nil
    end
    
    specify "body" do
      @reply.body = nil
    end
  end

  it "should relate to user" do
    Reply.reflect_on_association(:user).should_not be_nil
  end

  it "should relate to post" do
    Reply.reflect_on_association(:post).should_not be_nil
  end

end
