class RepliesController < ApplicationController
  
  layout false
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      Notifier.reply_notify(@reply)
      render :new
    else
      render :show
    end
  end
  
end
