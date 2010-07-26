class Organizer::AnnouncementsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index 
    @announcements = @organization.announcements.sort{ |a,b| b.created_at <=> a.created_at }
    @announcement = Announcement.new
  end

  def create
    @announcement = @organization.announcements.new(params[:announcement])
    if @announcement.save
      redirect_to organizer_announcements_url(@organization)
    else
      @announcements = @organization.announcements.sort{ |a,b| b.created_at <=> a.created_at }
      render :index
    end
  end
  
  protected
  
  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
