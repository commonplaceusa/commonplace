class CommunitiesController < ApplicationController
  before_filter :current_community

  def show
    redirect_to posts_url
  end

end
