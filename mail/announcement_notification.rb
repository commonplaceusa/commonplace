class AnnouncementNotification < PostNotification

  self.template_file = PostNotification.template_file

  def initialize(announcement_id, user_id)
    @announcement, @user = Announcement.find(announcement_id), User.find(user_id)
  end

  def subject
    "#{author_name} just posted an announcement to CommonPlace"
  end

  def post
    @announcement
  end

  def reply_to
    "reply+announcement_#{post.id}@ourcommonplace.com"
  end

  def author
    @announcement.owner
  end

  def community
    @announcement.community
  end

  def community_name
    community.name
  end

  def short_author_name
    case author
    when User then author.first_name
    when Feed then author.name
    end
  end

  def post_url
    show_announcement_url(post.id)
  end

  def new_message_url
    case author
    when User then message_user_url(author.id)
    when Feed then message_feed_url(author.id)
    else root_url
    end
  end

  def author_avatar_url
    author.avatar_url
  end

  def author_url
    case author
    when User then show_user_url(author.id)
    when Feed then show_feed_url(author.id)
    else root_url
    end
  end

  def user_name
    user.name
  end

  def tag
    'announcement'
  end

  def deliver?
    false
  end

end
