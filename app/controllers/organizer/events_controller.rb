class Organizer::EventsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index
    @events = @organization.events
    @event = Event.new
  end

  def show 
    @event = Event.find(params[:id])
  end


  def new
    @event = @organization.events.build
  end

  def create
    @event = @organization.events.build(params[:event])
    if @event.save
      redirect_to organizer_events_path(@organizer)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
  end

  protected
  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
