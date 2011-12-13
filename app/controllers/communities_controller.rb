class CommunitiesController < ApplicationController
  before_filter :authenticate_user!

  def good_neighbor_discount
    render :layout => "application"
  end
end
