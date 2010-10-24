class OrganizationsController < CommunitiesController
  before_filter :load, :except => :index
  authorize_resource

  layout 'zone'
  
  def index
    @items = current_community.organizations.all(:order => "name ASC")
  end

  def organization
    @items = current_community.organizations.organization.all(:order => "name ASC")
    render :index
  end

  def business
    @items = current_community.organizations.business.all(:order => "name ASC")
    render :index
  end

  def municipal
    @items = current_community.organizations
    render :index
  end

  def show
    render :layout => false
  end

  def profile
    render :layout => 'profile'
  end

  def new
    render :layout => false
  end

  def create
    @organization = current_community.organizations.new(params[:organization])
    if @organization.save
      @organization.admins << current_user
      redirect_to organization_profile_fields_url(@organization)
    else
      render :new, :layout => false
    end
  end

  def edit
    render :layout => false
  end

  def update
    if @organization.update_attributes(params[:organization])
      redirect_to organization_profile_fields_url(@organization)
    else
      render :edit, :layout => false
    end
  end
  
  protected
  def load
    @organization = 
      if params[:id]
        Organization.find(params[:id], :scope => current_community)
      else
        Organization.new
      end
  end
end
