class EventsController < ApplicationController
   
  def index
  end
  
  def new
    @event = Event.new
  end

  def create
   respond_to do |format|
     if @event.save
   #    format.html { redirect_to root_url }
       format.json         
     else
       format { render 'new' }
     end
   end
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
  
end
