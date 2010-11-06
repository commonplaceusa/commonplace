class Feeds::AnnouncementsController < CommunitiesController
  
  layout false

  def new
    @feed = Feed.find(params[:feed_id])
    @announcement = Announcement.new
  end

  def create
    @feed = Feed.find(params[:feed_id])
    @announcement = @feed.announcements.build(params[:announcement])
    if @announcement.save
      redirect_to management_feed_url(@feed)
    else
      render :new
    end
  end
end
