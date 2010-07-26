class Organizer::ProfilesController < ApplicationController

  before_filter :load_organization
  layout 'organizer'
  
  def show
    @profile_fields = @organization.profile_fields
    @profile_field = ProfileField.new
  end

  def create
    @profile_field = @organization.profile_fields.build(params[:profile_field])
    if @profile_field.save
      redirect_to organizer_profile_path(@organizer)
    else
      render :new
    end
  end

  protected

  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
