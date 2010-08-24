class CommunitiesController < ApplicationController
  before_filter :current_community

  def show
    respond_to do |format|
      if params[:q]
        @results = Event.tagged_with_aliases(params[:q], :any => true) + 
          User.tagged_with_aliases(params[:q], :any => true) + 
          Organization.tagged_with_aliases(params[:q], :any => true)
        format.json { render 'search' }
        format.html { render 'search' }
      else
        format.json
        format.html
      end
    end
  end

  private
  
  def current_community
    @current_community = Community.find_by_name(current_subdomain)
  end
  

end
