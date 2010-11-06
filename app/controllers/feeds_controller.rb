class FeedsController < CommunitiesController
  before_filter :load, :except => :index
  authorize_resource
  
  def index
    @items = current_community.feeds.all(:order => "name ASC")
  end

  def municipal
    @items = current_community.feeds
    render :index
  end

  def show
    if current_user.feeds.include?(@feed) && !flash.now[:message]
      flash.now[:message] = "You are subscribed to #{@feed.name}"
    end
  end

  def profile
    render :layout => 'profile'
  end

  def new
  end

  def create
    @feed = current_community.feeds.new(params[:feed])
    @feed.user = current_user
    if @feed.save
      redirect_to feed_url(@feed)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @feed.update_attributes(params[:feed])
      redirect_to feed_profile_fields_url(@feed)
    else
      render :edit
    end
  end
  
  protected
  def load
    @feed = 
      if params[:id]
        Feed.find(params[:id], :scope => current_community)
      else
        Feed.new
      end
  end
end
