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
    owner
  end

  def short_poster_name
    @announcement.owner.user.first_name
  end

  def announcement_url
    url("/announcements/#{announcement.id}")
  end

  def community
    announcement.community
  end

  def community_name
    community.name
  end

end
