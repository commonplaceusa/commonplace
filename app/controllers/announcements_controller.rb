class AnnouncementsController < CommunitiesController
  load_and_authorize_resource

  layout 'zone'

  def index
    @items = current_community.announcements.all(:order => "created_at DESC")
  end
  
  def subscribed
    @items = current_user.subscribed_announcements
    render :index
  end

  def show
    render :layout => false
  end

  def new
    render :layout => false
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      redirect_to announcements_url
    else
      render :new, :layout => false
    end
  end
end
