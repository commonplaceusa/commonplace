class FeedsController < CommunitiesController
  before_filter :load, :except => [:index,:show]
  authorize_resource
  
  def index
    if params[:letter].present?
      @items = current_community.feeds.all(:conditions => ["name ILIKE ?", params[:letter].slice(0,1) + "%"])
    else
      @items = current_community.feeds.all(:order => "name ASC")
    end
  end

  def municipal
    @items = current_community.feeds
    render :index
  end

  def show
    case params[:id]
    when /^\d+/
      @feed = Feed.find(params[:id])
      if current_user.feeds.include?(@feed) && !flash.now[:message]
        flash.now[:message] = "You are subscribed to #{@feed.name}"
      end
    else
      params[:action] = "profile"
      @feed = Feed.find_by_slug_and_community_id(params[:id],current_community.id)
      render :profile, :layout => false
    end
  end
  
  def import
    render :layout => xhr? ? 'application' : "/feeds/profile"
  end

  def profile
    render :layout => false
  end

  def new
    render :layout => 'application'
  end

  def create
    @feed = current_community.feeds.new(params[:feed])
    @feed.user = current_user
    if @feed.save
      redirect_to new_feed_invites_url(@feed)
    else
      render :new, :layout => 'application'
    end
  end

  def edit
    render :layout => 'application'
  end

  def update
    if @feed.update_attributes(params[:feed])
      redirect_to profile_feed_url(@feed)
    else
      render :edit, :layout => 'application'
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
