class Management::Organizations::ProfileFieldsController < ApplicationController

  def new
    @organization = Organization.find(params[:organization_id])
    @profile_field = ProfileField.new
    respond_to do |format|
      format.json
    end
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @profile_field = @organization.profile_fields.build(params[:profile_field])
    @profile_field.save
    redirect_to url_for([:management, @organization])
  end

  def order
    params[:fields].each_with_index do |id, index|
      ProfileField.update_all(["position=?", index+1], ["id=?", id])  
    end
    render :nothing => true
  end    
end
