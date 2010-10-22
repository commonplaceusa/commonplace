class Organizations::AnnouncementsController < CommunitiesController
  
  layout false

  def new
    @organization = Organization.find(params[:organization_id])
    @announcement = Announcement.new
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @announcement = @organization.announcements.build(params[:announcement])
    if @announcement.save
      redirect_to management_organization_url(@organization)
    else
      render :new
    end
  end
end
