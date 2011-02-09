class AttendancesController < CommunitiesController

  def create
    @event = Event.find(params[:event_id])
    unless @event.attendees.exists?(current_user)
      @event.attendees << current_user
    end
    flash[:message] = "You are attending #{@event.name}"
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event.attendees.delete(current_user)
    flash[:message] = "You are no longer attending #{@event.name}"
    redirect_to event_path(@event)
  end

end
