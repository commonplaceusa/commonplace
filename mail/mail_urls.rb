module MailUrls

  def url(path)
    if path.start_with?("http")
      path
    else
      if Rails.env.development?
        "http://localhost:5000" + path
      else
        "https://www.ourcommonplace.com" + path
      end
    end
  end

  def asset_url(path)
    if path.start_with?("http")
      path
    else
      "https://s3.amazonaws.com/commonplace-mail-assets-production/#{path}"
    end
  end

  def subscribe_url
    url("/feeds")
  end

  def new_event_url
    url("/new-event")
  end

  def new_announcement_url
    url("/new-post")
  end

  def new_post_url
    url("/new-post")
  end

  def new_invites_url
    url("/invites/new")
  end

  def new_feed_url
    url("/feed_registrations/new")
  end

  def new_group_post_url
    url("/new-group-post")
  end

  def starter_site_url
    "http://commonplaceusa.com"
  end

  def root_url
    url("/" + community.slug)
  end

  def logo_url
    asset_url("logo.png")
  end

  def settings_url
    url("/account/edit")
  end

  def faq_url
    url("/faq")
  end

  def feed_profile(feed)
    url("/pages/#{feed.slug}")
  end

  def inbox_url
    url("/inbox")
  end

end
