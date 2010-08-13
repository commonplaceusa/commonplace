class OrganizerController < ApplicationController

  before_filter :load_organization, :except => [:index, :new, :create]

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
    @organization = Organization.find params[:id]
  end
  
  def update
    @organization = Organization.find params[:id]
    @organization.update_attributes(params[:organization])
    redirect_to :show
  end
  
  def new
    @organization = Organization.new
    render :layout => 'application'
  end
  
  def create
    @organization = current_user.community.organizations.build(params[:organization])
    @organization.admins << current_user
    if @organization.save
      redirect_to organizer_url(@organization)
    else
      render :new
    end
  end

  protected
  
  def load_organization
    @organization = Organization.find(params[:id])
  end

end
