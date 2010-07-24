class OrganizerController < ApplicationController

  before_filter :load_organization, :except => [:index, :new]

  # filter_access_to :all
  
  def index
    @organizations = current_user.managable_organizations
    render :layout => 'application'
  end

  def show
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
  end

  protected
  
  def load_organization
    @organization = Organization.find(params[:id])
  end

end
