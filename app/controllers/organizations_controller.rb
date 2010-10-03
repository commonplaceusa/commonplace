class OrganizationsController < CommunitiesController
  
  before_filter :require_user, :only => :index
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
