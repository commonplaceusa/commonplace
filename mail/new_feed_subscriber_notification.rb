class NewFeedSubscriberNotification < MailBase

  def initialize(user_id, feed_id)
    @feed = Feed.find(feed_id)
    @feed_owner = User.find(feed.user_id)
    @user = User.find(user_id)
    @community = user.community
  end

  def user
    @user
  end

  def owner
    @feed_owner
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

  def user_name
    user.name
  end

  def header_image_url
    community_slug = community.slug.downcase
    asset_url("headers/single_post/#{community_slug}.png")
  end

  def user_url
    show_user_url(user.id)
  end

  def short_owner_name
    owner.first_name
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
    "#{short_user_name} subscribed to #{feed_name} on The #{town_name} CommonPlace"
  end

  def tag
    "new_feed_subscriber_notification"
  end

  def deliver?
    true
  end

end
