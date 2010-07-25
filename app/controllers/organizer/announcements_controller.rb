class Organizer::AnnouncementsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index 
    @announcements = @organization.announcements
    @announcement = Announcement.new
  end

  def create
    @announcement = @organization.announcements.build(params[:announcement])
    if @announcement.save
      redirect_to organizer_announcements_url(@organization)
    else
      render :new
    end
  end
  protected
  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
