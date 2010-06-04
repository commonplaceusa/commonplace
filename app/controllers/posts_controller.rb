class PostsController < ApplicationController
  
  def create
    @post = current_user.posts.build(params[:post])
    @post.save
    redirect_to root_url
  end

end
