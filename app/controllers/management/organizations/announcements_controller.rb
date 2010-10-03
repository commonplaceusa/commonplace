class Management::Organizations::AnnouncementsController < ManagementController
  load_and_authorize_resource :organization
  def index
    @organization = Organization.find(params[:organization_id])
    @announcements = @organization.announcements.all(:order => "created_at DESC")
    @announcement = Announcement.new
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @announcement = @organization.announcements.build(params[:announcement])
    if @announcement.save
      redirect_to management_organization_announcements_url(@organization)
    else
      @announcements = @organization.announcements
      render :index
    end
  end
end
