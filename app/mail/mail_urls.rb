module MailUrls

  def url(path)
    "http://#{community.slug}.ourcommonplace.com" + path
  end

  def subscribe_url
    url("/feeds")
  end

  def new_event_url
    url("/events/new")
  end

  def new_announcement_url
    url("/announcements/new")
  end

  def new_post_url
    url("/posts/new")
  end

  def new_invites_url
    url("/invites/new")
  end

  def new_feed_url
    url("/feeds/new")
  end

  def starter_site_url
    "http://commonplaceusa.com"
  end

  def root_url
    url("")
  end

  def logo_url
    url("/images/logo.png")
  end

  def settings_url
    url("/account/edit")
  end


end
