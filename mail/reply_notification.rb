class ReplyNotification < MailBase
  
  def initialize(reply_id, user_id)
    @reply, @user = Reply.find(reply_id), User.find(user_id)
  end

  def subject
    "#{replier_name} just replied to message on CommonPlace"
  end

  def community
    replier.community
  end

  def community_name
    community.name
  end

  def reply
    @reply
  end

  def repliable
    reply.repliable
  end

  def user
    @user
  end

  def user_name
    user.name
  end

  def replier
    reply.user
  end

  def reply_body
    markdown reply.body
  end

  def replier_avatar_url
    replier.avatar_url
  end

  def repliable_subject
    repliable.subject
  end
  
  def new_message_url
    url("/users/#{replier.id}/messages/new")
  end

  def repliable_url
    url("/#{repliable.class.name.downcase.pluralize}/#{repliable.id}")
  end

  def replier_name
    replier.name
  end

  def short_replier_name
    replier.first_name
  end

  def repliable_is_a_message?
    repliable.is_a? Message
  end

  
end
