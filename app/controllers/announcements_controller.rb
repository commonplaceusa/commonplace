class AnnouncementsController < CommunitiesController
  def index
    @announcements = current_community.announcements
    respond_to do |format|
      format.json
      format.html
    end
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.json
    end
  end

  def new
    @announcement = Announcement.new
    respond_to do |format|
      format.json
    end
  end
end
