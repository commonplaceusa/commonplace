require 'spec_helper'

describe PostsController do

  before :each do 
  end
  
  it "should allow a user to create a post" do
    
    activate_authlogic
    @user = Factory :user
    post :create, Factory.attributes_for(:post).merge(:user_id => @user.id)
    response.should be_redirect
  end

end
