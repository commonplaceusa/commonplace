class AnnouncementsController < CommunitiesController
  def index
    @subscribed_announcements = current_user.organizations.map(&:announcements).flatten
    @community_announcements = current_community.announcements.all(:conditions => ["announcements.id NOT IN (?)", @subscribed_announcements])

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
