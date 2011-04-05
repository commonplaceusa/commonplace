class FeedInvitation < Invitation

  def initialize(email, feed_id, message = nil)
    @to = email
    @feed = Feed.find(feed_id)
    @inviter = @feed.user
    @message = message.present? ? message : nil
  end

  def feed
    @feed
  end

  def feed_name
    @feed.name
  end

end
