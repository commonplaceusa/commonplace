class Management::Feeds::ProfileFieldsController < ManagementController

  def index
    @feed = Feed.find(params[:feed_id])
  end


  def new
    @feed = Feed.find(params[:feed_id])
    @profile_field = ProfileField.new
    respond_to do |format|
      format.json
    end
  end

  def create
    @feed = Feed.find(params[:feed_id])
    @profile_field = @feed.profile_fields.build(params[:profile_field])
    @profile_field.save
    redirect_to url_for([:management, @feed, :profile_fields])
  end

  def order
    params[:fields].each_with_index do |id, index|
      ProfileField.update_all(["position=?", index+1], ["id=?", id])  
    end
    render :nothing => true
  end    
  
  def destroy
    @feed = Feed.find(params[:feed_id])
    @profile_field = ProfileField.find(params[:id])
    @profile_field.destroy
    redirect_to management_feed_profile_fields_url(@feed)
  end

  def update
    @profile_field = ProfileField.find(params[:id])
    @profile_field.update_attributes(params[:profile_field])
    render :nothing => true
  end
end
