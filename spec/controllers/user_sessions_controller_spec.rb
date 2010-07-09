require 'spec_helper'

describe UserSessionsController do
  
  context "logged in user" do 
    before :each do
      login({:destroy => true, :email => "", :password => ""},{})
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
    
  it "should allow a guest to create a session" do
    get :new
    response.should render_template(:new)
    UserSession.stub!(:new => mock_model(UserSession, :save => true))
    post :create
    response.should be_redirect
  end
  
  it "should not allow a guest to log out" do
    delete :destroy
    response.should_not be_success
  end

end

