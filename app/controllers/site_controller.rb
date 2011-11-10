class SiteController < ApplicationController

  layout 'application'

  def index 
    @request = Request.new
    render :layout => 'starter_site'
  end

  def privacy ; end

  def terms ; end

  def whereami
    # notes
    # test location with organizers
    # create form allow people to change location on their own
    # save location data for the home page, track on mpq
    # as we scale, lets NOT rely on freegeoip.net
    require 'net/http'
    url = URI.parse("http://freegeoip.net/json/#{request.remote_ip}")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    location = JSON.parse(res.body)
    # 66.31.47.137 :
    # {"city":"Cambridge",
    # "region_code":"MA",
    # "region_name":"Massachusetts",
    # "metrocode":"506",
    # "zipcode":"02138",
    # "longitude":"-71.1329",
    # "country_name":"United States",
    # "country_code":"US",
    # "ip":"66.31.47.137",
    # "latitude":"42.38"}
    community = Community.find_by_slug(location["city"])

    if community
      redirect_to community_landing_path(community.slug)
    else
      @request = Request.new({community_name: "#{location['city']}, #{location['region_code']}"})
      render 'site/index', :layout => 'starter_site'
      #render :text => "no community: <a href='#{root_path}'>#{root_path}</a><br/><br/><pre>#{location.to_yaml}</pre>"
    end
  end
  
end
