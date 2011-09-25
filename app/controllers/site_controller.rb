class SiteController < ApplicationController

  layout 'application'

  def index 
    @request = Request.new
    render :layout => 'starter_site'
  end

  def privacy ; end

  def terms ; end
  
end
