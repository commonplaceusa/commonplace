class EventsController < ApplicationController
  filter_resource_access

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
end
