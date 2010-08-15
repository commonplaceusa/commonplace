class Events::RepliesController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    @reply = @event.replies.build(params[:reply].merge(:user => current_user))
    @reply.save
    redirect_to root_url
  end

end
