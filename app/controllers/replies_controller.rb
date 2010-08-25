class RepliesController < ApplicationController
  
  def create
    @reply = current_user.replies.build(params[:reply])
    respond_to do |format|
      if @reply.save
        Notifier.reply_notify(@reply)
        format.json
      else
        format.json { render :new }
      end
    end
  end

end
