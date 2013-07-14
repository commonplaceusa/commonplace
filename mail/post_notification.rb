class PostNotification < MailBase

  def initialize(post_id, user_id)
    @post, @user = Post.find(post_id), User.find(user_id)
  end

  def logo_url
    asset_url("logo2.png")
  end

  def subject
    "#{author_name} just posted to your neighborhood on OurCommonPlace."
  end

  def reply_to
    "reply+post_#{post.id}@ourcommonplace.com"
  end

  def post
    @post
  end

  def user
    @user
  end

  def author
    @post.user
  end

  def community
    @post.community
  end

  def author_name
    author.name
  end

  def short_author_name
    author.first_name
  end

  def post_url
    show_post_url(post.id)
  end

  def new_message_url
    message_user_url(author.id)
  end

  def title
    post.subject
  end

  def body
    post.body
  end

  def author_avatar_url
    author.avatar_url(:thumb)
  end

  def has_avatar
    author.avatar?
  end

  def author_url
    show_user_url(author.id)
  end

  def user_name
    user.name
  end

  def tag
    'single_post'
  end

  def limited?
    user.emails_are_limited?
  end

  def short_user_name
    user.first_name
  end

  def deliver?
    false
  end
end
