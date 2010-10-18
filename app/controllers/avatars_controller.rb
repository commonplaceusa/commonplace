class AvatarsController < ApplicationController

  layout false

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
  end
  
end
