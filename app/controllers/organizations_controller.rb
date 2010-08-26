class OrganizationsController < CommunitiesController
  
  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.organizations.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @subscribed_organizations = current_user.organizations
        @suggested_organizations = []
        @community_organizations = current_community.organizations.all(:conditions => ["id NOT IN (?)", @subscribed_organizations + @suggested_organizations + [0]])
        format.json
        format.html
      end
    end
  end

  def show
    @organization = Organization.find params[:id]
    respond_to do |format|
      format.json 
      format.html { render :layout => 'application' }
    end
  end

  def new
    @organization = Organization.new
    respond_to do |format|
      format.json 
    end
  end
  
end
