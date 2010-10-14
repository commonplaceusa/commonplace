class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community
  def show
  end

end
