class MessageNotification < PostNotification
  
  def initialize(message_id, user_id)
    @message, @user = Message.find(message_id), User.find(user_id)
  end

  def limited?
    false
  end

  def subject
    "#{sender_name} just sent you a private message through CommonPlace"
  end

  def message
    @message
  end

  def sender
    message.user
  end

  def reply_to
    "reply+message_#{message.id}@ourcommonplace.com"
  end

  def community
    user.community
  end
    
  def community_name
    community.name
  end

  def sender_name
    sender.name
  end

  def short_sender_name
    sender.first_name
  end

  def message_url
    inbox_url
  end

  def new_message_url
    message_user_url(sender.id)
  end

  def message_subject
    message.subject
  end

  def message_body
    markdown(message.body)
  end

  def sender_avatar_url
    sender.avatar_url
  end

  def sender_url
    show_user_url(sender.id)
  end

  def user_name
    user.name
  end

  def tag
    'message'
  end

end
