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
    if @post.respond_to?(:subject)
      @post.subject
    elsif @post.respond_to?(:title)
      @post.title
    end
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

    adverb = author == @post.user ? "just" : "also"
    possesive = author == @post.user ? "your" : @post.user.name + "'s"
    post_text =
      case @post
      when Message then "private message"
      when Post then "post"
      when Event then "event"
      when Announcement then "an announcement"
      when GroupPost then "a post on the #{community_name} #{@post.group.name} Group"
      end

    "#{author_name} #{adverb} replied to #{possesive} #{post_text} on CommonPlace."
  end

  def tag
    'reply'
  end

end
