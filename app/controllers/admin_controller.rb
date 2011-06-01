class AdminController < ApplicationController

  def overview
    @communities = Community.all
    @completed_registrations = User.where("created_at < updated_at")
    @incomplete_registrations = User.where("created_at >= updated_at")
    @emails_opened_today = 1
    @emails_opened = 1
    render :layout => nil
  end
end
