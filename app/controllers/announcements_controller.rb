class AnnouncementsController < CommunitiesController
  load_and_authorize_resource

  def index
    @items = current_community.announcements.all(:order => "created_at DESC")
  end
  
  def subscribed
    @items = current_user.subscribed_announcements
    render :index
  end

  def show
  end

  def new
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      @announcement.feed.notifications.create(:notifiable => @announcement)
      redirect_to announcements_url
    else
      render :new
    end
  end
end
