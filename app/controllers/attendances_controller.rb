class AttendancesController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    @attendance = @event.attendances.build(:user => current_user)
    if @attendance.save
      render :show
    else
      render :create
    end
  end
                        
  def destroy
    @attendance = Attendance.find(params[:id])
    @event = @attendance.event

    current_user.events.delete(@event)
    render :destroy
  end

end
