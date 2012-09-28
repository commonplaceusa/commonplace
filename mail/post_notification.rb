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

  def header_image_url
    asset_url("headers/#{community.slug}.png")
  end

  def reply_to
    "reply+post_#{post.id}@ourcommonplace.com"
  end

  def reply_button_url
    asset_url("reply-now-button.png")
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
    
  def community_name
    community.name
  end

  def community_home_url
    community.links.base
  end

  def community_slug
    community.slug
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
    url("/users/#{author.id}")
  end

  def user_name
    user.name
  end

  def tag
    'post'
  end

  def limited?
    user.emails_are_limited?
  end

  def short_user_name
    user.first_name
  end
end
