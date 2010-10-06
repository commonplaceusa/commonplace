class OrganizationsController < CommunitiesController
  before_filter :load, :except => :index
  authorize_resource
  
  def index
    @organizations = current_community.organizations
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
