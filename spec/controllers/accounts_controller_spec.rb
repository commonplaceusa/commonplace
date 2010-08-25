
require 'spec_helper'

describe AccountsController do
  
  it "should allow a guest to create an account" do

    post :create, :user => {}
    new_instance_of(User).save { true }
    response.should be_success
  end

  it "should not allow a logged in user to create an account" do
    login
    post :create, :user => {}
    response.should_not be_success
  end

  it "should render create template on a successful create" do
    new_instance_of(User).save { true }
    stub(controller).reload_current_user!
    post :create, :user => {}
    response.should render_template('create')
  end

  it "should render the edit template" do
    login
    get :edit
    response.should render_template('edit')
  end
  
  it "should re-render edit on a failed update" do
    login
    stub(current_user).valid? { false }
    put :update
    response.should render_template('edit')
  end

  it "should redirect to account on a successful update" do
    login
    stub(current_user).update_attributes { true }
    put :update
    response.should redirect_to(account_url)
  end
end
