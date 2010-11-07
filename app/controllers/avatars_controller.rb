class AvatarsController < CommunitiesController

  def edit
    @avatar = Avatar.find(params[:id])
  end

  def update
    @avatar = Avatar.find(params[:id])
    @avatar.update_attributes(params[:avatar])
    @avatar.save
    redirect_to management_url
  end
  
end
