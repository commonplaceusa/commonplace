class Organizer::EventsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index
    @events = @organization.events
    @event = @organization.events.build
  end

  def show 
    @event = Event.find(params[:id])
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
