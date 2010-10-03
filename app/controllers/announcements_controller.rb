class AnnouncementsController < CommunitiesController
  load_and_authorize_resource
  def index
    @announcements = current_community.announcements.all(:order => "created_at DESC")
    respond_to do |format|
      format.json
      format.html
    end
  end
  
  def show
    respond_to do |format|
      format.json
    end
  end

  def new
    respond_to do |format|
      format.json
    end
  end
end
