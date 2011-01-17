class Feeds::InvitesController < ApplicationController

  def new
    @feed = Feed.find(params[:feed_id])
  end

  def create
    @feed = Feed.find(params[:feed_id])
    params[:emails].split(",").each do |email|
      unless User.exists?(:email => email)
        InviteMailer.deliver_feed_invite(@feed.id,email)
      end
    end
    redirect_to feed_profile_path(@feed)
  end
  
end
