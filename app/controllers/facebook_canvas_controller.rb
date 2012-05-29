require 'open-uri'

class FacebookCanvasController < ApplicationController
  
  def index
    request_id = params[:request_ids]
    url = "https://graph.facebook.com/oauth/access_token?&client_id=#{$FacebookConfig['app_id']}&client_secret=#{$FacebookConfig['app_secret']}&grant_type=client_credentials"
    begin
      application_token = open(url).read.gsub("access_token=","")
      graph_url = "https://graph.facebook.com/#{request_id}?access_token=#{application_token}"
      @slug = ActiveSupport::JSON.decode(open(URI.encode(graph_url)).read)["data"]
    rescue
      redirect_to "/" and return
    end
    render :layout => nil
  end

end
