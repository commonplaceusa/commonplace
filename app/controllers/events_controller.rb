class EventsController < CommunitiesController
  load_and_authorize_resource
  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.events.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @events = current_community.events
        format.json
        format.html
      end
    end
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
