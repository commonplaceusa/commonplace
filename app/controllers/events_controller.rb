class EventsController < CommunitiesController
  before_filter :owner
  load_and_authorize_resource :except => [:index, :new]
  
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
    @event = Event.new(params[:event].merge(:owner => @owner))
    if @event.save
      redirect_to events_path
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
  
  def owner
    if params[:event] && params[:event][:owner]
      owner_class, owner_id = params[:event].delete(:owner).try(:split, "_")
      @owner = owner_class.capitalize.constantize.find(owner_id.to_i)
    end
  end
end

