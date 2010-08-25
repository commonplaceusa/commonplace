require 'spec_helper'

describe RepliesController do

  it "should let users create replies" do
    stub(current_user).replies.stub!.build { stub(Reply.new).save { true } }
    stub(Notifier).reply_notifier
    login
    post :create, :reply => {}
    response.should render_template('create')
  end

end
