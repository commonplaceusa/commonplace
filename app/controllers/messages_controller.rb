class MessagesController < ApplicationController

  layout false

  def new
    @user = User.find(params[:user_id])
    @message = Message.new(:conversation => Conversation.new)
  end

  def create
    @user = User.find(params[:user_id])
    @message = @user.messages.build(params[:message])
    if @message.save
      flash.now[:message] = "Message sent to #{@user.name}"
    else
      render :new
    end
  end
end
