class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
end
