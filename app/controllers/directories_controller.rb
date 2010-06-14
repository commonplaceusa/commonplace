class DirectoriesController < ApplicationController

  def people
    @entries = User.all
    render "index"
  end
  
  def events
    @entries = Event.all
    render "index"
  end
  
  def businesses
    @entries = Business.all
    render "index"
  end
  
  def organizations
    @entries = Organization.all
    render "index"
  end
  
  def all
    if params[:id].nil?
      @events = Event.all
      @people = User.all
      render "show"
    else
      @entries = (User.all | Event.all).shuffle # special case:
      render "index"                            # a little of everything
    end
  end

  def show
    @events = Event.all
    @people = User.all
    # @organizations = Organization.all
    # @businesses = Business.all
  end

end
