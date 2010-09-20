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

  def conversation
    @event = Event.find(params[:id])
  end

  def replies
    @event = Event.find(params[:id])
    @reply = @event.replies.new(params[:reply].merge(:user => current_user))
    @reply.official = true

    respond_to do |format|
      if @reply.save
        format.json {render :json => {:success => true}}
      else
        format.json
      end
    end
  end
  
end
