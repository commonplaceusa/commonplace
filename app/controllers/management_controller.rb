class ManagementController < ApplicationController
  
  def show
    authorize!(:read, :management)
  end


  protected
  
  def current_ability
    @current_ability ||= ManagementAbility.new(current_user)
  end
end
