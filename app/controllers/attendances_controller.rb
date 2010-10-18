class AttendancesController < ApplicationController

  layout false

  def create
    @event = Event.find(params[:event_id])
    unless @event.attendees.exists?(current_user)
      @event.attendees << current_user
    end
    flash.now[:message] = "You are attending #{@event.name}"
    render :show
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event.attendees.delete(current_user)
    flash.now[:message] = "You are no longer attending #{@event.name}"
    render :show
  end

end
