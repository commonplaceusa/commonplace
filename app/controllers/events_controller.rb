class EventsController < ApplicationController
   
  def index
    @events = Event.all
  end
  
  def new
    @event = Event.new
  end

  def create
   @event = Event.new(params[:event])
   respond_to do |format|
     if @event.save
   #    format.html { redirect_to root_url }
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
