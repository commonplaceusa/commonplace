class AvatarsController < ApplicationController

  def edit
    @avatar = Avatar.find(params[:id])
    respond_to do |format|
      format.json
    end
  end

  def update
    @avatar = Avatar.find(params[:id])
    @avatar.update_attributes(params[:avatar])
    @avatar.save
    # We can't send json because firefox will try to download it.
    render :text => {".normal.#{dom_id(@avatar)}" => @avatar.image.url(:normal)}.to_json
  end
  
end
