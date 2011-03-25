class Feeds::InvitesController < ApplicationController

  def new
    @feed = Feed.find(params[:feed_id])
  end

  def create
    @feed = Feed.find(params[:feed_id])
    params[:emails].split(/,|\r\n|\n/).each do |email|
      unless User.exists?(:email => email)
        Resque.enqueue(FeedInvitation, email, @feed.id)
      end
    end
    redirect_to feed_profile_path(@feed)
  end
  
end
