class NoFeedPermission < MailBase
  
  def initialize(user_id, feed_id)
    @user, @feed = User.find(user_id), Feed.find(feed_id)
  end

  def subject
    "CommonPlace announcement did not go through"
  end

  def user
    @user
  end
  
  def feed
    @feed
  end

  def feed_name
    @feed.name
  end

  def community
    @user.community
  end

  def community_name
    community.name
  end

  def organizer_email
    community.organizer_email
  end

end
