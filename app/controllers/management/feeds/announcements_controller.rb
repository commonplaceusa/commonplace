class Management::Feeds::AnnouncementsController < ManagementController
  load_and_authorize_resource :feed
  def index
    @feed = Feed.find(params[:feed_id])
    @announcements = @feed.announcements.all(:order => "created_at DESC")
    @announcement = Announcement.new
  end
  
  def create
    @feed = Feed.find(params[:feed_id])
    @announcement = @feed.announcements.build(params[:announcement])
    if @announcement.save
      redirect_to management_feed_announcements_url(@feed)
    else
      @announcements = @feed.announcements
      render :index
    end
  end
  
  def destroy
    @feed = Feed.find(params[:feed_id])
    @announcement = Announcement.find(params[:id])
    @announcement.destroy
    redirect_to management_feed_announcements_url(@feed)
  end
    
end
