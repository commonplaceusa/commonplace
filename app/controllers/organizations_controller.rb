class OrganizationsController < CommunitiesController
  
  def index
    @subscribed_organizations = current_user.organizations
    @suggested_organizations = current_user.related_of_class(Organization).all(:conditions => ["organizations.id NOT IN (?)", @subscribed_organizations + [0]])
    @community_organizations = current_community.organizations.all(:conditions => ["id NOT IN (?)", @subscribed_organizations + @suggested_organizations])
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @organization = Organization.find params[:id]
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
    @subscribers = @organization.subscribers

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
