class RepliesController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(params[:reply].merge(:user => current_user))
    respond_to do |format|
      if @reply.save
        format.json
      else
        format.json { render :show }
      end
    end
  end

end
