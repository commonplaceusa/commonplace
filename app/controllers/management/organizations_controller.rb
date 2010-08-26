class Management::OrganizationsController < ManagementController
  
  def show
    @organization = Organization.find(params[:id])
  end

  def edit
    @organization = Organization.find(params[:id])
  end
  
  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new params[:organization]
    if @organization.save
      current_user.managable_organizations << @organization
      current_user.save
      redirect_to management_organization_url(@organization)
    else
      render :new
    end
  end
  
  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      redirect_to edit_management_organization_url(@organization)
    else
      render :edit
    end
  end  
end
