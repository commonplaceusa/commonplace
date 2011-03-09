class AnnouncementsController < CommunitiesController
  load_and_authorize_resource

  def index
    @items = current_community.announcements.all(:order => "updated_at DESC")
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
    @announcement = Announcement.new(params[:announcement].merge(:community => current_community))
    if @announcement.save
      redirect_to announcements_path
    else
      render :new
    end
  end

  def edit ; end
  
  def update
    if @announcement.update_attributes(params[:announcement])
      redirect_to announcement_url(@announcement)
    else
      render :edit
    end
  end

  def destroy
    @announcement.destroy
    redirect_to announcements_url
  end
  
end
