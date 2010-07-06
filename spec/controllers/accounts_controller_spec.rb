require 'spec_helper'

describe AccountsController do

  it "should render the new template" do
    get :new
    response.should render_template('new')
    assigns[:account].should_not be_nil
  end

  it "should re-render the new template on a failed create" do
    post :create
    response.should render_template('new')
    assigns[:account].should_not be_nil
  end

  context 'logged in' do
    before :each do 
      activate_authlogic
      UserSession.new(Factory(:user))
    end
    
    it "should render the edit template" do
      get :edit
      response.should render_template('edit')
    end

  end
end
