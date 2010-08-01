class SiteController < ApplicationController

  filter_access_to :all
  layout "public"
  
  def index 
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
