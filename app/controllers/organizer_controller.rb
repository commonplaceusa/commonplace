class OrganizerController < ApplicationController

  before_filter :load_organization, :except => [:index, :new]

  # filter_access_to :all
  
  def index
    @organizations = current_user.managable_organizations
    if @organizations.length == 0
      redirect_to new_organizer_url
    elsif @organizations.length == 1
      redirect_to organizer_url(@organizations.first)
    else
      render :layout => 'application'
    end
  end

  def show
    @subscribers = @organization.subscribers
    render :show
  end

  def edit
  end
  
  def update
  end
  
  def new
    @organization = Organization.new
    render :layout => 'application'
  end
  
  def create
    @organization = current_user.managable_organizations.build(params[:organization])
    @organization.community = current_user.community
  end

  protected
  
  def load_organization
    @organization = Organization.find(params[:id])
  end

end
