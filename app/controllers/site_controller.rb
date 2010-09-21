class SiteController < ApplicationController
  
  def index 
    @communities = Community.all
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
