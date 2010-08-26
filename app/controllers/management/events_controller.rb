class Management::EventsController < ManagementController

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to management_event_url(@event)
    else
      render :edit
    end
  end


end
