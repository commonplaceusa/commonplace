class OrganizerController < ApplicationController

  before_filter :load_organization, :except => :index

  # filter_access_to :all
  
  def index
    @organizations = current_user.managable_organizations
  end

  def show
    render :show
  end

  def edit
  end

  protected
  
  def load_organization
    @organization = Organization.find(params[:id])
  end

end
