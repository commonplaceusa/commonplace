class ManagementController < ApplicationController
  
  def show
  end


  protected
  
  def current_ability
    @current_ability ||= ManagementAbility.new(current_user)
  end
end
