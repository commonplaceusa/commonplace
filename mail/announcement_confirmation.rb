class AnnouncementConfirmation < MailBase

  def initialize(announcement_id)
    @announcement = Announcement.find(announcement_id)
  end

  def announcement
    @announcement
  end

  def owner
    @announcement.owner
  end

  def user
    owner.user
  end

  def short_poster_name
    @announcement.owner.user.first_name
  end

  def announcement_url
    show_announcement_url(@announcement.id)
  end

  def community
    announcement.community
  end

  def community_name
    community.name
  end

  def tag
    'announcement_confirmation'
  end

  def deliver?
    false
  end

end
