class ProfileFieldsController < CommunitiesController

  layout false

  def index
    @organization = Organization.find(params[:organization_id])
  end

  def edit
    @profile_field = ProfileField.find(params[:id])
  end

  def update
    @profile_field = ProfileField.find(params[:id])
    if @profile_field.update_attributes(params[:profile_field])
      redirect_to organization_profile_fields_path(@profile_field.organization)
    else
      render :edit
    end
  end

end
