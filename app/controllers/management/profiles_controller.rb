class Management::ProfilesController < ApplicationController

  before_filter :load_organization
  layout 'management'
  
  def show
    @profile_fields = @organization.profile_fields
    @profile_field = ProfileField.new
  end

  def create
    @profile_field = @organization.profile_fields.build(params[:profile_field])
    if @profile_field.save
      redirect_to management_profile_path(@management)
    else
      render :new
    end
  end

  protected

  def load_organization
    @organization = Organization.find(params[:management_id])
  end
end
