class Feeds::AnnouncementsController < ApplicationController

  layout :choose_layout

  def new
    @feed = Feed.find(params[:feed_id])
    @announcement = Announcement.new
  end

  def create
    @feed = Feed.find(params[:feed_id])
    @announcement = @feed.announcements.build(params[:announcement].merge(:community => current_community))
    if @announcement.save
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
