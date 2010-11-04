class FirstPostsController < ApplicationController

  def new
    @post = Post.new
    render :layout => false
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      flash[:message] = "Post Created!"
      redirect_to posts_url
    else
      render :new, :layout => false
    end
  end

end
