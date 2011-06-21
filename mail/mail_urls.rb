module MailUrls

  def url(path)
    if Rails.env.development?
      "http://localhost:3000" + path
    else
      "http://ourcommonplace.com" + path
    end
  end

  def asset_url(path)
    if Rails.env.development?
      "http://localhost:3000" + path
    else
      "http://ourcommonplace.com" + path
    end
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

  def new_group_post_url
    url("/group_posts/new")
  end

  def starter_site_url
    "http://commonplaceusa.com"
  end

  def root_url
    url("/" + community.slug)
  end

  def logo_url
    asset_url("/images/logo.png")
  end

  def settings_url
    url("/account/edit")
  end

  def faq_url
    url("/faq")
  end

end
