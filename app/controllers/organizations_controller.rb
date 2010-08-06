class OrganizationsController < CommunitiesController
  
  def index
    @organizations = current_user.community.organizations
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @organization = Organization.find params[:id]
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
    @subscribers = @organization.subscribers
    render :layout => 'application'
  end

  def new
    @organization = Organization.new
    respond_to do |format|
      format.json 
    end
  end
  
end
