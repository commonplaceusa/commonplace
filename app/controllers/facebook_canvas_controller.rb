class FacebookCanvasController < ApplicationController
  
  def index
    @request_id = params[:request_ids]
    render :layout => nil
  end

end
