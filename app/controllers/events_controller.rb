class EventsController < CommunitiesController
   
  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.events.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @subscribed_events = current_user.organizations.map(&:events).flatten
        @suggested_events = []
        @community_events = current_community.events.all(:conditions => ["events.id NOT IN (?)", @subscribed_events + @suggested_events + [0]])
        
        format.json
        format.html
      end
    end
  end
  
  def new
    @event = Event.new
    respond_to do |format|
      format.json
    end
  end

  def create
    @event = Event.new(params[:event])
    
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
    @event = Event.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
  
end
