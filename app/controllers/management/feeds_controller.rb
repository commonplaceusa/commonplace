class Management::FeedsController < ManagementController
  before_filter :load
  authorize_resource

  def show
  end

  def edit
  end
  
  def new
  end

  def create
    if @feed.save
      current_user.managable_feeds << @feed
      current_user.save
      redirect_to management_feed_url(@feed)
    else
      render :new
    end
  end
  
  def update
    if @feed.update_attributes(params[:feed])
      redirect_to management_feed_url(@feed)
    else
      render :show
    end
  end  
  
  def outreach
    @feed = Feed.find(params[:id])
    @possible_subscribers = User.tagged_with_aliases(@feed.tags.map(&:name), :any => true)
  end
  
  def load
    @feed = 
      if params[:id] 
        Feed.find(params[:id], :scope => current_community)
      else
        Feed.new
      end
  end
end
