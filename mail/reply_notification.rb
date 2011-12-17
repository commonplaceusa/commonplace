class ReplyNotification < MailBase
  
  def initialize(reply_id, user_id)
    @reply, @user = Reply.find(reply_id), User.find(user_id)
  end

  def subject
    subject_line
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
  
  def reply_to
    "reply+#{repliable.class.name.downcase}_#{repliable.id}@ourcommonplace.com"
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
    message_user_url(replier.id)
  end

  def repliable_url
    case repliable
    when Event then show_event_url(repliable.id)
    when GroupPost then show_group_post_url(repliable.id)
    when Announcement then show_announcement_url(repliable.id)
    when Post then show_post_url(repliable.id)
    when Message then show_message_url(repliable.id)
    end
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
  
  def subject_line
    if @user.community.is_college
      post_subject = "a hall board post"
    else
      post_subject = "a post"
    end
    post_type = case repliable
                when Message then "a private message"
                when Post then post_subject
                when Event then "an event"
                when Announcement then "an announcement"
                end
    "#{replier_name} just replied to #{post_type} on CommonPlace."
  end

  def tag
    'reply'
  end

end
