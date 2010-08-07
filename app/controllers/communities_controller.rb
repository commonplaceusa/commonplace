class CommunitiesController < ApplicationController
  before_filter :current_community

  def show
    respond_to do |format|
      format.json
      format.html
    end
  end

  private
  
  def current_community
    @current_community = Community.find_by_name(current_subdomain)
  end
  

end
