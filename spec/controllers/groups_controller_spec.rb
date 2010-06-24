require 'spec_helper'

describe GroupsController do
  
  context "logged in" do
    before :each do
      activate_authlogic
      Factory :user
    end

    it "should respond to new" do
      get :new
      response.should be_success
    end

  end    

end
