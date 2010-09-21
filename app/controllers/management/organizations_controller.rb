class Management::OrganizationsController < ManagementController
  load_and_authorize_resource

  def show
  end

  def edit
  end
  
  def new
  end

  def create
    if @organization.save
      current_user.managable_organizations << @organization
      current_user.save
      redirect_to management_organization_url(@organization)
    else
      render :new
    end
  end
  
  def update
    if @organization.update_attributes(params[:organization])
      redirect_to management_organization_url(@organization)
    else
      render :edit
    end
  end  
  
  def outreach
    @organization = Organization.find(params[:id])
    @possible_subscribers = User.tagged_with_aliases(@organization.tags.map(&:name), :any => true)
  end
end
