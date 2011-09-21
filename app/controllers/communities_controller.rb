class CommunitiesController < ApplicationController
  before_filter :current_community, :current_neighborhood

  def good_neighbor_discount
    render :layout => "application"
  end
end
