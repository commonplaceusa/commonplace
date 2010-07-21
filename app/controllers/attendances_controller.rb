class AttendancesController < ApplicationController


  def update 
    @event = Event.find(params[:event_id])
    if params[:attending]
      @attendance = @event.attendances.build(:user_id => current_user, :attending => params[:attending])
      @attendance.attending
      @attendance.save
    else
      current_user.events.delete(@event)
    end
    redirect_to '/'
  end

end
