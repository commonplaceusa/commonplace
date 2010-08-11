require 'spec_helper'

describe AccountsController do
  
  it "should allow a guest to create an account" do
    post :create, :user => Factory.attributes_for(:user)
    response.should be_success
  end

  it "should not allow a logged in user to create an account" do
    login
    post :create, :user => Factory.attributes_for(:user)
    response.should_not be_success
  end

  it "should render create template on a successful create" do
    controller.stub!(:current_user, nil)
    UserSession.stub!(:find).and_return(user_session({},{:roles => [:user]}))
    User.stub!(:new).and_return(mock_model(User, :save => true))
    post :create, :user => {}
    response.should render_template('create')
  end

  it "should render the edit template" do
    login({},{:roles => [:user]})
    get :edit
    response.should render_template('edit')
  end
  
  it "should re-render edit on a failed update" do
    login({},{:update_attributes => false, :roles => [:user]})
    put :update
    response.should render_template('edit')
  end

  it "should redirect to account on a successful update" do
    login({},{:update_attributes => true, :roles => [:user]})
    put :update
    response.should redirect_to(account_url)
  end
end
