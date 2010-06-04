class RepliesController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(params[:reply])
    @reply.user = current_user
    @reply.save
    redirect_to root_url
  end

end
