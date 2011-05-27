require 'net/http'
require 'json'
require 'url'

class FacebookCanvasController < ApplicationController
  
  def index
    @request_id = params[:request_ids]
    url = URI.parse("http://graph.facebook.com/" + @request_id + "/")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @data = JSON.parse(res.body)
    render :layout => nil
  end

end
