class NSubscribersFeedNotification < MailBase
  def initialize(feed_id)
    @feed = Feed.find(feed_id)
    @owner = @feed.user
  end

  def to
    @owner.email
  end

  def subject
    "#{self.feed_name} has #{self.number_of_subscribers} subscribers on the #{self.community_name} CommonPlace!"
  end

  def first_name
    @owner.first_name
  end

  def feed_name
    @feed.name
  end

  def community
    @owner.community
  end

  def community_name
    community.name
  end

  def invitation_link
    new_invites_url
  end

  def number_of_subscribers
    Feed.subscriber_count_email_trigger
  end

  def tag
    'feed_subscriber_notification'
  end

  def deliver?
    false
  end
end
