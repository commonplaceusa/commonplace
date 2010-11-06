class Management::SubscriptionsController < ApplicationController

  before_filter :load_feed
  layout "management"

  def index
    @subscriptions = @feed.subscriptions
  end


  protected
  def load_feed
    @feed = Feed.find(params[:management_id])
  end

end
