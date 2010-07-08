require 'spec_helper'

describe PostsController do

  before :each do 
    login({},{:roles => [:user]})
    Post.stub!(:new).and_return(mock_model(Post, :save => true))
  end
  
  it "should allow a user to create a post" do

    post :create, :post => {}
    response.should redirect_to('/')
  end

end
