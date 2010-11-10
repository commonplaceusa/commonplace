class Management::EventsController < ManagementController
  load_and_authorize_resource :event

  def show
  end

  def edit
  end
  
  def update
    if @event.update_attributes(params[:event])
      redirect_to management_event_url(@event)
    else
      render :edit
    end
  end

  def replies
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

  def outreach
    @event = Event.find(params[:id])
    @possible_attendees = User.tagged_with_aliases(@event.tags.map(&:name), :any => true)
  end
  
end
