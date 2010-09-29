class OrganizationsController < CommunitiesController
  before_filter :load, :except => :index
  authorize_resource
  
  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.organizations.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @organizations = current_community.organizations
        format.json
        format.html
      end
    end
  end

  def show
    respond_to do |format|
      format.json 
      format.html { render :layout => 'application' }
    end
  end

  def new
    respond_to do |format|
      format.json 
    end
  end
  
  def claim
    case request.request_method
    when :get
      respond_to do |format|
        format.json 
      end
    when :post
      if params[:code] == @organization.code
        @organization.admins << current_user
        @organization.claimed = true
        @organization.save
        redirect_to management_organization_url(@organization)
      else
        render :claim
      end
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
