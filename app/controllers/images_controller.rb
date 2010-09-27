class ImagesController < ApplicationController

  def new
    respond_to do |format|
      format.json
    end
  end
  
  def edit
    @avatar = current_user.avatar
    respond_to do |format|
      format.json
    end
  end
  
  
end
