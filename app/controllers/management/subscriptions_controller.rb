class Management::SubscriptionsController < ApplicationController

  before_filter :load_organization
  layout "management"

  def index
    @subscriptions = @organization.subscriptions
  end


  protected
  def load_organization
    @organization = Organization.find(params[:management_id])
  end

end
