class AnnouncementsController < CommunitiesController
  def index
    @announcements = Announcement.all
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
end
