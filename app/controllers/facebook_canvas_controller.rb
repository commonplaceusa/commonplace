require 'open-uri'

class FacebookCanvasController < ApplicationController
  
  def index
    @request_id = params[:request_ids]
    url = "https://graph.facebook.com/oauth/access_token?&client_id=#{$FacebookConfig['app_id']}&client_secret=#{$FacebookConfig['app_secret']}&grant_type=client_credentials"
    @application_token = open(url).read.gsub("access_token=","")
    render :layout => nil
  end

end
