class Organizer::SubscriptionsController < ApplicationController

  before_filter :load_organization
  layout "organizer"

  def index
    @subscriptions = @organization.subscriptions
  end


  protected
  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end

end
