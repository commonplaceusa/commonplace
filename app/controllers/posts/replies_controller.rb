class Posts::RepliesController < ApplicationController
  filter_access_to :all
  
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(params[:reply].merge(:user => current_user))
    respond_to do |format|
      if @reply.save
        @post.users.each do |user|
          user.notifications.create(:notifiable => @post) unless user == @reply.user
        end
        @post.user.notifications.create(:notifiable => @post) unless @post.user == @reply.user
        format.json
      else
        format.json { render :show }
      end
    end
  end

end
