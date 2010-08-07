class SiteController < ApplicationController

  filter_access_to :all
  
  def index 
    @communities = Community.all
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
