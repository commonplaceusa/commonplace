class OrganizationsController < CommunitiesController
  
  def index
    @organizations = current_user.community.organizations
  end

  def show
    @organization = Organization.find params[:id]
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
    @subscribers = @organization.subscribers
    render :layout => 'profile'
  end
  
end
