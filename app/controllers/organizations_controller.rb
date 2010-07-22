class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find_by_id(params[:id])
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
  end
  
end
