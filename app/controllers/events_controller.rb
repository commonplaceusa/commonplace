class EventsController < CommunitiesController
  load_and_authorize_resource
  def index
    @events = current_community.events
  end
  
  def new
    respond_to do |format|
      format.json
    end
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
