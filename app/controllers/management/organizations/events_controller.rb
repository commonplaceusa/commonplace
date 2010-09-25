class Management::Organizations::EventsController < ManagementController
  load_and_authorize_resource :organization

  def index
    @events = @organization.events.all(:order => "date DESC")
    @event = Event.new
  end

  def create
    @event = @organization.events.build(params[:event])
    if @event.save
      redirect_to management_event_url(@event)
    else
      @events = @organizations.events
      render :index
    end
  end
end
