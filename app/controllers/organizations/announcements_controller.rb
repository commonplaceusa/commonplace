class Organizations::AnnouncementsController < CommunitiesController
  
  def new
    @organization = Organization.find(params[:organization_id])
    @announcement = Announcement.new
    respond_to do |format|
      format.json { render }
    end
  end
end
