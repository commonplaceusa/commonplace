class Organizer::AnnouncementsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index 
    @announcements = @organization.announcements
    @announcement = @organization.announcements.build
  end

  protected
  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
