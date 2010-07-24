class Organizer::ProfilesController < ApplicationController

  before_filter :load_organization
  layout 'organizer'
  
  def show
  end


  protected

  def load_organization
    @organization = Organization.find(params[:organizer_id])
  end
end
