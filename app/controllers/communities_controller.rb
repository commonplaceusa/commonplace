class CommunitiesController < ApplicationController
  before_filter :current_community

  def show
    respond_to do |format|
      if params[:q]
        @results = Event.tagged_with_aliases(params[:q], :any => true) + 
          User.tagged_with_aliases(params[:q], :any => true) + 
          Organization.tagged_with_aliases(params[:q], :any => true)
        format.html { render 'search' }
        format.json { render 'search' }

      else
        format.html
        format.json

      end
    end
  end


  

end
