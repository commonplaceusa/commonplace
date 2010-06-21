class PostsController < ApplicationController
  filter_resource_access
  
  def create
    @post = current_user.posts.build(params[:post])
    respond_to do |format|
      if @post.save
        format.json         
      else
        format.json { render 'new' }
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
    
end
