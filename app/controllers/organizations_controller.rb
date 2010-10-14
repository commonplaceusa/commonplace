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
      format.json 
      format.html { render :layout => 'profile' }
    end
  end

  def new
    respond_to do |format|
      format.json 
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
