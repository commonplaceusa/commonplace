require 'spec_helper'

describe RepliesController do

  it "should let users create replies" do
    @reply = mock_model(Reply, :save => true)
    Notifier.stub(:reply_notifier)
    reply_proxy = mock(:build => @reply)
    login({},{:replies => reply_proxy})
    post :create, :reply => {}
    response.should render_template('create')
  end

end
