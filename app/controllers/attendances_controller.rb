class AttendancesController < ApplicationController


  def update 
    @event = Event.find(params[:event_id])
    if params[:attending]
      @attendance = @event.attendances.build(:user => current_user)
      @attendance.save
    else
      current_user.events.delete(@event)
    end
  end

end
