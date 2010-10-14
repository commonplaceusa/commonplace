class EventsController < CommunitiesController
  load_and_authorize_resource

  layout false
  
  def index
    @events = current_community.events
  end

  def your
    @events = current_user.events
    render :index
  end

  def suggested
    @events = current_user.suggested_events
    render :index
  end
  
  def new
  end

  def create
    respond_to do |format|
      if @event.save
        format.json         
      else
        format { render 'new' }
      end
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
