class AnnouncementsController < CommunitiesController
  load_and_authorize_resource

  layout false

  def index
    @announcements = current_community.announcements.all(:order => "created_at DESC")
  end
  
  def subscribed
    @announcements = current_user.subscribed_announcements
    render :index
  end

  def show
    respond_to do |format|
      format.json
    end
  end

  def new
  end
end
