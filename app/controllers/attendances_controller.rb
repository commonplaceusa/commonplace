class AttendancesController < ApplicationController


  def create
    @event = Event.find(params[:event_id])
    unless @event.attendees.exists?(current_user)
      @event.attendees << current_user
    end
    redirect_to root_url      
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event.attendees.delete(current_user)
    redirect_to root_url
  end

end
