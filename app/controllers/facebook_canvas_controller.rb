require 'net/http'
require 'json'
require 'url'

class FacebookCanvasController < ApplicationController
  
  def index
    @request_id = params[:request_ids]
    url = "https://graph.facebook.com/oauth/access_token?&client_id=179741908724938&client_secret=4d1d96dc9b402ca6779f77bc9e88b89a&grant_type=client_credentials"
    @application_token = JSON.parse(open(url).read)
    render :layout => nil
  end

end
