class Events::RepliesController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    @reply = @event.replies.build(params[:reply].merge(:user => current_user))
    respond_to do |format|
      if @reply.save
        format.json
      else
        format.json { render :show }
      end
    end
  end

end
