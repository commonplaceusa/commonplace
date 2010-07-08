require 'spec_helper'

describe RepliesController do

  it "should let users create replies" do
    login
    @reply = mock_model(Reply, :save => true)
    @post = mock_model(Post, :replies => mock(:build => @reply))
    Post.stub!(:find => @post)
    post :create, :reply => {}
    response.should render_template('create')
  end

end
