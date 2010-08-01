require 'spec_helper'

describe ThreadMembership do
  before(:each) do
    @user = Factory :user
    @user2 = Factory :user
    @thread = Thread.new
    @thread.contributers << @user
    @thread.contributers << @user
  end

    
end
