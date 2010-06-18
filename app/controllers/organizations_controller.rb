class OrganizationsController < ApplicationController

  
  def show
    @organization = Organization.find(params[:id])
  end

  
  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:success] = "Organization saved"
      redirect_to edit_organization_url
    else
      flash.now[:error] = "There was an error in your Organization"
      render :edit
    end
  end
  
  

end
