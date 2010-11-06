class ClaimsController < CommunitiesController
  before_filter :feed

  def new
    render :layout => false
  end
  
  def create
    if params[:code] == @feed.code
      @feed.admins << current_user
      @feed.claimed = true
      @feed.save
      redirect_to edit_feed_url(@feed)
    else
      flash.now[:error] = "Sorry, that claim code is not valid."
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.json 
    end
  end

  def update
    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.json 
      else
        format.json
      end
    end
  end

  def edit_fields
    respond_to do |format|
      format.json
    end
  end

  protected

  def feed
    @feed = Feed.find(params[:feed_id])
  end

end
