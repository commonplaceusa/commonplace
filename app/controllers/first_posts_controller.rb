class FirstPostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      flash[:message] = "Post Created!"
      redirect_to posts_url(:format => :json)
    else
      render :new
    end
  end

end
