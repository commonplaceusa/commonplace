require 'spec_helper'

describe UserSessionsController do
  before :each do
    @user = Factory(:user)
  end
  
  context "logged in user" do 
    before :each do
      activate_authlogic
      UserSession.create(@user)
    end
    
    it "should not allow a logged in user to create a session" do
      get :new
      response.should_not be_success
      post :create, :email => @user.email, :password => @user.password
      response.should_not be_success
    end
    
    it "should allow a logged in user to log out" do
      delete :destroy
      response.should 
    end
    
  end
    
  it "should allow a guest to create a session" do
    get :new
    response.should be_success
    post :create, :email => @user.email, :password => @user.password
    response.should be_success
  end
  
  it "should not allow a guest to log out" do
    delete :destroy
    response.should_not be_success
  end

end

