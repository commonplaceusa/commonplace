class OrganizationsController < CommunitiesController
  load_and_authorize_resource
  
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
  
end
