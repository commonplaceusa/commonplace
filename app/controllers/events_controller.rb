class EventsController < CommunitiesController
  before_filter :owner
  load_and_authorize_resource :except => [:index]
  
  def index
    @items = current_community.events.upcoming
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
    @event = Event.new(params[:event].merge(:owner => @owner, :community => current_community))
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end
  
  def edit ; end

  def update
    if @event.update_attributes(params[:event].merge(:owner => @owner))
      redirect_to event_url(@event)
    else
      render :edit
    end
  end



  def show
    if current_user.events.include?(@event) && !flash.now[:message]
      flash.now[:message] = "You are attending #{@event.name}"
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url
  end

  protected
  def owner
    if params[:event] && params[:event][:owner]
      owner_class, owner_id = params[:event].delete(:owner).try(:split, "_")
      @owner = owner_class.capitalize.constantize.find(owner_id.to_i)
    end
  end
end

