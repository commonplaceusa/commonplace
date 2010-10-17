class EventsController < CommunitiesController
  load_and_authorize_resource

  layout 'zone'
  
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
    render :layout => false
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      redirect_to events_url
    else
      render :new, :layout => false
    end
  end
  
  def update
  end

  def show
    respond_to do |format|
      format.json
    end
  end
  
end
