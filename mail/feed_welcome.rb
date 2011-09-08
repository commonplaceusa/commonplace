class FeedWelcome < MailBase

  def initialize(user_id, feed_id)
    @user = User.find(user_id)
    @community = user.community
    @feed = Feed.find(feed_id)
  end

  def user
    @user
  end

  def community
    @community
  end

  def feed
    @feed
  end

  def town_name
    community.name
  end

  def short_user_name
    user.first_name
  end

  def feed_name
    feed.name.titlecase
  end

  def feed_url
    feed_profile(feed)
  end

  def feed_email_address
    "#{feed.slug}@OurCommonPlace.com"
  end

  def organizer_email
    community.organizer_email
  end

  def organizer_name
    community.organizer_name
  end

  def subject
    "Your {feed_name} feed on The {town_name} CommonPlace"
  end

  def tag
    "feed_welcome"
  end

end
