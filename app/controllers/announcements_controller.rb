class AnnouncementsController < CommunitiesController
  def index
    @organizations = current_user.organizations
    @announcements = @organizations.map(&:announcements).flatten.sort{ |a,b| b.created_at <=> a.created_at }
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
