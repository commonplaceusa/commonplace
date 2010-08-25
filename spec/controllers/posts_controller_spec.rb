require 'spec_helper'

describe PostsController do

  before :each do 
    login
    post = Post.new
    stub(post).save { true }
    stub(post).user { current_user }
    stub(Post).new { post }
  end
  
  it "should allow a user to create a post" do
    post :create, :post => {}
    response.should redirect_to(root_url)
  end

end
