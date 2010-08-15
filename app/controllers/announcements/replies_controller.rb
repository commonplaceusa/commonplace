class Announcements::RepliesController < ApplicationController

  def create
    @announcement = Announcement.find(params[:announcement_id])
    @reply = @announcement.replies.build(params[:reply].merge(:user => current_user))
    respond_to do |format|
      if @reply.save
        format.json
      else
        format.json { render :show }
      end
    end
  end
end
