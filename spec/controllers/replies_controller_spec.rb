require 'spec_helper'

describe RepliesController do

 context "when logged in" do
    before :each do
      activate_authlogic
      @user = Factory :user
    end
    
    it "should let users create replies" do
      post :create, Factory.attributes_for(:reply).merge(:post_id => Factory(:post).id,
                                                         :user_id => @user.id)
      response.should be_redirect
    end

  end

end
