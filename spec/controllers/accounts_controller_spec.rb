require 'spec_helper'

describe AccountsController do

  it "should render the new template" do
    get :new
    response.should render_template('new')
    assigns[:account].should_not be_nil
  end
  
  it "should allow a guest to create an account" do
    get :new
    response.should be_success
    post :create, Factory.attributes_for(:user).merge(:code => CONFIG["code"])
    response.should be_success
  end

  it "should not allow a user to create an account" do
    activate_authlogic
    user = Factory :user
    get :new
    response.should_not be_success
    post :create, Factory.attributes_for(:user).merge(:code => CONFIG["code"])
    response.should_not be_success
  end

  it "should re-render the new template on a failed create" do
    post :create
    response.should render_template('new')
    assigns[:account].should_not be_nil
  end

  it "should render more_info on a successful create" do
    UserSession.stub!(:find).and_return(user_session({},{}))
    Account.stub!(:new).and_return(mock_model(Account, :save => true))
    post :create
    response.should render_template('more_info')
  end

  it "should render the edit template" do
    login
    get :edit
    response.should render_template('edit')
  end
  
  it "should re-render edit on a failed update" do
    login({},{:update_attributes, false})
    put :update
    response.should render_template('edit')
  end

  it "should redirect to root on a successful update" do
    login({},{:update_attributes, true})
    put :update
    response.should redirect_to('/')
  end
end
