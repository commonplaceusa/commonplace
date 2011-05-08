class AnnouncementsController < CommunitiesController
  before_filter :owner
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
    @announcement = Announcement.new(params[:announcement].merge(:community => current_community, :owner => @owner))
    if @announcement.save
      if @announcement.owner.is_a?(Feed)
        @announcement.owner.live_subscribers.each do |user|
          Resque.enqueue(AnnouncementNotification, @announcement.id, user.id)
        end
      end
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
  
  protected 
  def owner
    if params[:announcement] && params[:announcement][:owner]
      owner_class, owner_id = params[:announcement].delete(:owner).try(:split, "_")
      @owner = owner_class.capitalize.constantize.find(owner_id.to_i)
    end
  end
end
