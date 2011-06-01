class AdminController < ApplicationController

  def overview
    @communities = Community.all
    render :layout => nil
  end
end
