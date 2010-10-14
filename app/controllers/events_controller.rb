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
