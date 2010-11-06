class ProfileFieldsController < CommunitiesController

  layout false

  def index
    @feed = Feed.find(params[:feed_id])
  end

  def order
    params[:fields].each_with_index do |id, index|
      ProfileField.update_all(["position=?", index+1], ["id=?", id])
    end
    render :nothing => true
  end
  

  def new
    @feed = Feed.find(params[:feed_id])
    @profile_field = ProfileField.new
  end
  
  def create
    @feed = Feed.find(params[:feed_id])
    @profile_field = @feed.profile_fields.build(params[:profile_field])
    if @profile_field.save
      render :show
    else
      render :new
    end
  end

  def edit
    @profile_field = ProfileField.find(params[:id])
  end

  def update
    @profile_field = ProfileField.find(params[:id])
    if @profile_field.update_attributes(params[:profile_field])
      @feed = @profile_field.feed
      render :show
    else
      render :edit
    end
  end

end
