class MessageNotification < PostNotification
  
  def initialize(message_id, user_id)
    @message, @user = Message.find(message_id), User.find(user_id)
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
    url("/messages/#{message.id}")
  end

  def new_message_url
    url("/users/#{sender.id}/messages/new")
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
    url("/users/#{sender.id}")
  end

  def user_name
    user.name
  end
  
end
