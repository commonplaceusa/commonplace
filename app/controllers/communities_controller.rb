class CommunitiesController < ApplicationController
  
  layout 'community'

  def show
    @post = Post.new
  end



end
