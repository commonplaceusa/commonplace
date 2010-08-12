class EventsController < CommunitiesController
   
  def index
    @events = Event.all.reverse
    respond_to do |format|
      format.json
      format.html
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
