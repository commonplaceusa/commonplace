class ShareNotification < MailBase

  def initialize(user, item, recipient_email)
    @recipient = recipient_email
    @post = item
    @user = user
  end

  def data_type
    @post.class.to_s.downcase
  end

  def to
    @recipient
  end

  def subject
    if @post.community.is_college
      "#{poster_name} just posted to your hall board on CommonPlace"
    else
      "#{poster_name} just posted to our neighborhood on CommonPlace"
    end
  end

  def reply_to
    "reply+post_#{post.id}@ourcommonplace.com"
  end

  def post
    @post
  end

  def poster
    @post.user
  end

  def sharer
    @user
  end

  def community
    @post.community
  end

  def community_name
    community.name
  end

  def sharer_name
    sharer.name
  end

  def short_sharer_name
    sharer.first_name
  end

  def poster_name
    poster.name
  end

  def short_poster_name
    poster.first_name
  end

  def post_url
    show_post_url(@post.id)
  end

  def new_message_url
    message_user_url(poster.id)
  end

  def post_subject
    @post.subject
  end

  def post_body
    markdown(@post.body) rescue ("<p>" + @post.body + "</p>")
  end

  def poster_avatar_url
    asset_url(poster.avatar_url(:thumb))
  end

  def poster_url
    community_url("/")
  end

  def deliver?
    true
  end

  def tag
    'sharing'
  end
end
