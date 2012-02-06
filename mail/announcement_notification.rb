class AnnouncementNotification < PostNotification

  self.template_file = PostNotification.template_file

  def initialize(announcement_id, user_id)
    @post, @user = Announcement.find(announcement_id), User.find(user_id)
  end

  def subject
    "#{author_name} posted an new announcement on CommonPlace"
  end

  def reply_to
    "reply+announcement_#{post.id}@ourcommonplace.com"
  end

  def author
    @post.owner
  end
    
  def short_author_name
    author_name
  end

  def post_url
    show_announcement_url(post.id)
  end

  def new_message_url
    message_feed_url(author.id)
  end

  def author_url
    url("/feeds/#{author.id}")
  end

  def tag
    'announcement'
  end
  
end
