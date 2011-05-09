class SubscriptionsController < CommunitiesController

  def index
    @items = current_community.feeds.all(:order => "name ASC")
  end

  def recommended
    @items = Feed.all
    render :index
  end
  
  def create
    @feed = Feed.find params[:feed_id]
    current_user.feeds << @feed
    flash[:message] = "You've subscribed to #{ @feed.name }."
    render :create, :layout => false
  end
  
  def destroy
    @feed = Feed.find params[:feed_id]
    current_user.feeds.delete @feed
    current_user.save
    flash[:message] = "You've unsubscribed from #{ @feed.name }."
    render :create, :layout => false
  end
end
