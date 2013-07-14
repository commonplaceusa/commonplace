class MessageNotification < PostNotification

  self.template_file = PostNotification.template_file

  def initialize(message_id, user_id)
    @post, @user = Message.find(message_id), User.find(user_id)
  end

  def limited?
    false
  end

  def subject
    "#{author_name} just sent you a private message through CommonPlace"
  end

  def reply_to
    "reply+message_#{post.id}@ourcommonplace.com"
  end

  def community
    user.community
  end

  def post_url
    inbox_url + "#" + post.id.to_s
  end

  def tag
    'message'
  end

end
