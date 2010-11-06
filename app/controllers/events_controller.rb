class EventsController < CommunitiesController
  load_and_authorize_resource
  
  def index
    @items = current_community.events
  end

  def your
    @items = current_user.events
    render :index
  end

  def suggested
    @items = current_user.suggested_events
    render :index
  end
  
  def new
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      redirect_to events_url
    else
      render :new
    end
  end
  
  def update
  end

  def show
    if current_user.events.include?(@event) && !flash.now[:message]
      flash.now[:message] = "You are attending #{@event.name}"
    end
  end
  
end
