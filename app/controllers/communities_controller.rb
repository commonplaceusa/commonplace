class CommunitiesController < ApplicationController
  
  layout 'community'
  
  def show
    @community = Community.find params[:id]
    @post = Post.new
  end
  
end
