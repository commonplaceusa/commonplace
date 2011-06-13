class AdminController < ApplicationController

  def overview
    @days = 14
    date = @days.days.ago
    @start_year = date.strftime("%Y")
    @start_month = date.strftime("%m")
    @start_day = date.strftime("%d")
    @communities = Community.all.select{|c| c.users.count > 0 and c.households != nil and c.households > 1 and c.core}.sort{|a,b| a.users.count <=> b.users.count}
    @completed_registrations = User.where("created_at < updated_at")
    @incomplete_registrations = User.where("created_at >= updated_at")
    @emails_opened_today = 1
    @emails_opened = 1
    render :layout => nil
  end
end
