require 'spec_helper'

describe UserSessionsController do
  
  context "logged in user" do 
    before :each do
      login
    end
    
    it "should not be allowed to create a session" do
      get :new
      response.should_not be_success
      post :create
      response.should_not be_success
    end
    
    it "should be allowed to log out" do
      delete :destroy
      response.should redirect_to(root_url)
    end
    
  end
    
  context "logged out user" do
    before :each do

    end
    it "should allow a guest to create a session" do
      new_instance_of(UserSession).save { true }
      stub(controller).reload_current_user!
      post :create
      response.should be_redirect
    end
    
    it "should not allow a guest to log out" do
      delete :destroy
      response.should_not be_success
    end
  end

end

