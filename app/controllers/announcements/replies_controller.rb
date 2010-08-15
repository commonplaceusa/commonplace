class Announcements::RepliesController < ApplicationController

  def create
    @announcement = Announcement.find(params[:announcement_id])
    @reply = @announcement.replies.build(params[:reply].merge(:user => current_user))
    @reply.save
    redirect_to root_url
  end
end
