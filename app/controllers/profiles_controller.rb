class ProfilesController < ApplicationController

  before_filter :load_organization
  filter_access_to :all, :model => :organization

  def edit
  end

  def update
    if @organization.save
      redirect_to edit_organizer_profile_url(@organization)
    else 
      render :edit
    end
  end
  
  protected
  
  def load_organization
    @organization = Organization.find(params[:organization_id])
  end
    

end
