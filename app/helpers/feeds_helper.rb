module FeedsHelper

  def feed_profile_path(feed)
    if feed.slug
      feed_path(feed.slug)
    else
      profile_feed_path(feed)
    end
  end

  def feed_profile_url(feed)
    if feed.slug
      feed_url(feed.slug)
    else
      profile_feed_url(feed)
    end
  end

end
