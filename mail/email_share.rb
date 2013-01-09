class EmailShare < PostNotification

  self.template_file = PostNotification.template_file

  def initialize(recipients, postlike_id, postlike_type, community_id, sharing_user_id)
    @recipients = recipients
    @postlike = postlike_type.constantize.find(postlike_id)
    @postlike_type = postlike_type
    @community = Community.find(community_id)
    @user = User.find(sharing_user_id)
  end

  def post
    @postlike
  end

  def post_type
    @postlike_type
  end

  def postlike
    @postlike
  end

  def post_url
    show_post_url(postlike.id) if post_type == "Post"
  end

  def new_message_url
    if author.is_a? User
      message_user_url(author.id)
    elsif author.is_a? Feed
      message_feed_url(author.id)
    end
  end

  def to
    @recipients
  end

  def author
    @postlike.try(:owner)
  end

  def community
    @community
  end

  def community_name
    community.name
  end

  def short_user_name
    ""
  end

  def short_sharer_name
    if user.is_a? User
      user.first_name
    elsif user.is_a? Feed
      user.name
    end
  end

  def organizer_email
    community.organizer_email
  end

  def organizer_name
    community.organizer_name
  end

  def subject
    "Your friend #{short_sharer_name} wanted you to see this #{post_type.titlecase} on the #{community_name} OurCommonPlace"
  end

  def tag
    "email_postlike_share"
  end

  # def deliver?
    # true
  # end

end
