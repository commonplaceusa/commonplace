class SubscriptionsController < ApplicationController

  layout false

  def index
    @organizations = current_user.organizations
  end

  def recommended
    @organizations = Organization.all
    render :index
  end
  
  def create
    @organization = Organization.find params[:organization_id]
    current_user.organizations << @organization
    flash[:win] = "You've subscribed to #{ @organization.name }."
    redirect_to @organization
  end
  
  def destroy
    @organization = Organization.find params[:organization_id]
    current_user.organizations.delete @organization
    current_user.save
    flash[:win] = "You've unsubscribed from #{ @organization.name }."
    redirect_to @organization
  end
end
