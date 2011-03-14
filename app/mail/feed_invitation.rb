class FeedInvitation < Invitation

  def initialize(feed, message = nil)
    @feed = feed
    super(feed.user, message)
  end

  def feed 
    @feed
  end

  def feed_name
    @feed.name
  end

end
