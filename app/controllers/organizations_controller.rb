class OrganizationsController < CommunitiesController
  before_filter :load, :except => :index
  authorize_resource

  layout 'zone'
  
  def index
    @items = current_community.organizations
  end

  def business
    @items = current_community.organizations
    render :index
  end

  def municipal
    @items = current_community.organizations
    render :index
  end

  def show
    respond_to do |format|
      format.html { render :profile, :layout => 'profile' }
      format.text { render :layout => false }
    end
  end

  def new
    render :layout => false
  end

  def create
    @organization = current_community.organizations.new(params[:organization])
    if @organization.save
      @organization.admins << current_user
      redirect_to organizations_url
    else
      render :new, :layout => false
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
