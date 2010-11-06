class Management::AnnouncementsController < ApplicationController

  before_filter :load_feed
  layout "management"

  def index 
    @announcements = @feed.announcements.sort{ |a,b| b.created_at <=> a.created_at }
    @announcement = Announcement.new
  end

  def create
    @announcement = @feed.announcements.new(params[:announcement])
    if @announcement.save
      redirect_to management_announcements_url(@feed)
    else
      @announcements = @feed.announcements.sort{ |a,b| b.created_at <=> a.created_at }
      render :index
    end
  end
  
  protected
  
  def load_feed
    @feed = Feed.find(params[:management_id])
  end
end
