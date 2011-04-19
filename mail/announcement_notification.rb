class AnnouncementNotification < PostNotification
  
  def initialize(announcement_id, user_id)
    @announcement, @user = Announcement.find(announcement_id), User.find(user_id)
  end

  def subject
    "#{poster_name} just posted a message to your neighborhood"
  end

  def announcement
    @announcement
  end

  def user
    @user
  end

  def poster
    @announcement.owner
  end

  def community
    @announcement.community
  end
    
  def community_name
    community.name
  end

  def poster_name
    poster.name
  end

  def short_poster_name
    case poster
    when User then poster.first_name
    when Feed then poster.name
    end
  end

  def announcement_url
    url("/announcements/#{announcement.id}")
  end

  def new_message_url
    case poster
    when User then url("/users/#{poster.id}/messages/new")
    when Feed then url("/feeds/#{poster.id}/messages/new")
    else root_url
    end
  end

  def announcement_subject
    announcement.subject
  end

  def announcement_body
    markdown(announcement.body)
  end

  def poster_avatar_url
    poster.avatar_url
  end

  def poster_url
    case poster
    when User then url("/users/#{poster.id}")
    when Feed then url("/feeds/#{poster.id}")
    else root_url
    end
  end

  def user_name
    user.name
  end
  
end
