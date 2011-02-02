require 'spec_helper'

describe Message do

  before :each do 
    @message = Message.new
  end

  it "should require a subject" do
    @message.valid?
    @message.should have(1).errors_on(:subject)
  end

  it "should require a body" do
    @message.valid?
    @message.should have(1).errors_on(:body)
  end

  it "should require a user (owner)" do
    @message.valid?
    @message.should have(1).errors_on(:user)
  end

  it "should require a messagable" do
    @message.valid?
    @message.should have(1).errors_on(:messagable)
  end

  it "should be repliable" do
    @message.replies.build.should be_a(Reply)
  end

end
