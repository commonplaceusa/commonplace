class Management::Feeds::EventsController < ManagementController
  load_and_authorize_resource :feed

  def index
    @past = @feed.events.past(:order => "date DESC")
    @upcoming = @feed.events.upcoming(:order => "date DESC")
    @event = Event.new
  end

  def create
    @event = @feed.events.build(params[:event])
    if @event.save
      redirect_to management_event_url(@event)
    else
      @past = @feed.events.past(:order => "date DESC")
      @upcoming = @feed.events.upcoming(:order => "date DESC")
      render :index
    end
  end
end
