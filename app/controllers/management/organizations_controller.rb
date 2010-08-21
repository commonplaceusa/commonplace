class Management::OrganizationsController < ManagementController
  
  def index
    @organizations = current_user.managable_organizatiosn
  end

  def show
    @organization = Organization.find params[:id]
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.managable_organizations.build params[:organization]
    if @organization.save
      redirect_to management_organization_url(@organization)
    else
      render :new
    end
  end
end
