class Management::EventsController < ApplicationController

  before_filter :load_organization
  layout "management"

  def index
    @events = @organization.events
    @event = Event.new
  end

  def create
    @event = @organization.events.build(params[:event])
    if @event.save
      redirect_to management_events_path(@management)
    else
      render :index
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
    @organization = Organization.find(params[:management_id])
  end
end
