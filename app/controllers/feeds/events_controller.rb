class Feeds::EventsController < ApplicationController
  
  layout :choose_layout

  def new
    @feed = Feed.find(params[:feed_id])
    @event = Event.new
  end

  def create
    @feed = Feed.find(params[:feed_id])
    @event = @feed.events.build(params[:event].merge(:community => current_community))
    if @event.save
      render :create
    else
      render :new
    end
  end

  private
  def choose_layout
    xhr? ? 'application' : '/feeds/profile.haml' 
  end

end
