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
    "reply+message_#{message.id}@ourcommonplace.com"
  end

  def post_url
    inbox_url
  end

  def new_message_url
    message_user_url(author.id)
  end

  def tag
    'message'
  end

end
