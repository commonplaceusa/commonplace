class ReplyNotification < MailBase
  
  def initialize(reply, user)
    @reply, @user = reply, user
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
