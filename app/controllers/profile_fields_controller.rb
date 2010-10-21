class ProfileFieldsController < CommunitiesController

  layout false

  def index
    @organization = Organization.find(params[:organization_id])
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @profile_field = ProfileField.new
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @profile_field = @organization.profile_fields.build(params[:profile_field])
    if @profile_field.save
      redirect_to organization_profile_fields_url(@organization)
    else
      render :new
    end
  end

  def edit
    @profile_field = ProfileField.find(params[:id])
  end

  def update
    @profile_field = ProfileField.find(params[:id])
    if @profile_field.update_attributes(params[:profile_field])
      redirect_to organization_profile_fields_url(@profile_field.organization)
    else
      render :edit
    end
  end

end
