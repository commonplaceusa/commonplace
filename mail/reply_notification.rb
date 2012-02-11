class ReplyNotification < PostNotification

  self.template_file = PostNotification.template_file  

  def initialize(reply_id, user_id)
    @reply, @user = Reply.find(reply_id), User.find(user_id)
    @post = @reply.repliable
  end

  def subject
    subject_line
  end

  def reply
    @reply
  end

  def user
    @user
  end
  
  def reply_to
    "reply+#{@post.class.name.downcase}_#{@post.id}@ourcommonplace.com"
  end

  def user_name
    user.name
  end

  def author
    reply.user
  end

  def body
    reply.body
  end

  def title
    @post.subject
  end

  def new_message_url
    message_user_url(author.id)
  end

  def repliable_url
    case @post
    when Event then show_event_url(@post.id)
    when GroupPost then show_group_post_url(@post.id)
    when Announcement then show_announcement_url(@post.id)
    when Post then show_post_url(@post.id)
    when Message then show_message_url(@post.id)
    end
  end

  def subject_line
    post_type = case @post
                when Message then "a private message"
                when Post then "a post"
                when Event then "an event"
                when Announcement then "an announcement"
                when GroupPost then "a post on the #{@post.group.name} Group"
                end
    "#{author_name} just replied to #{post_type} on CommonPlace."
  end

  def tag
    'reply'
  end

end
