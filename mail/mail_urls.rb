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

  def community_url(path)
    url("/#{community.slug}#{path}")
  end

  def community_home_url(path)
    community_url("")
  end

  def asset_url(path)
    if path.start_with?("http")
      path
    else
      "https://s3.amazonaws.com/commonplace-mail-assets-production/#{path}"
    end
  end

  def show_announcement_url(id)
    community_url("/show/announcements/#{id}")
  end

  def show_user_url(id)
    community_url("/show/users/#{id}")
  end

  def show_feed_url(id)
    community_url("/show/feeds/#{id}")
  end

  def show_post_url(id)
    community_url("/show/posts/#{id}")
  end

  def show_event_url(id)
    community_url("/show/events/#{id}")
  end

  def show_message_url(id)
    community_url("/inbox")
  end

  def show_group_post_url(id)
    community_url("/show/group_posts/#{id}")
  end

  def message_feed_url(id)
    community_url("/message/feeds/#{id}")
  end

  def message_user_url(id)
    community_url("/message/users/#{id}")
  end

  def subscribe_url
    community_url("/list/feeds")
  end

  def new_event_url
    community_url("/share/event")
  end

  def new_announcement_url
    community_url("/share/announcement")
  end

  def new_post_url
    community_url("/share/post")
  end

  def new_invites_url
    community_url("/invite")
  end

  def new_feed_url
    url("/feed_registrations/new")
  end

  def new_group_post_url
    community_url("/share/group_post")
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
    community_url("/account")
  end

  def faq_url
    community_url("/faq")
  end

  def feed_profile(feed)
    url("/pages/#{feed.slug}")
  end

  def inbox_url
    url("/inbox")
  end

  def copyright_year
    DateTime.now.strftime("%Y")
  end

end
