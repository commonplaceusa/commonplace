require 'spec_helper'

describe PostsController do

  before :each do 
    login({:roles => [:user]},{})
    post = mock_model(Post, :save => true, :user => current_user)
    Post.stub!(:new).and_return(post)
  end
  
  it "should allow a user to create a post" do

    post :create, :post => {}
    response.should redirect_to(root_url)
  end

end
