class RepliesController < ApplicationController
  
  def create
    @reply = current_user.replies.build(params[:reply])
    @item = @reply.repliable
    respond_to do |format|
      if @reply.save
        @item.repliers.each do |user|
          user.notifications.create(:notifiable => @item) unless user == current_user
        end
        format.json
      else
        format.json { render :new }
      end
    end
  end

end
