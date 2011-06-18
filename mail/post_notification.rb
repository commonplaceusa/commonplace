class PostNotification < MailBase
  
  def initialize(post_id, user_id)
    @post, @user = Post.find(post_id), User.find(user_id)
  end

  def logo_url
    asset_url("/images/logo2.png")
  end

  def subject
    "#{author_name} just posted a message to your neighborhood"
  end

  def reply_to
    "reply+post_#{post.id}@ourcommonplace.com"
  end

  def reply_button_url
    asset_url("/images/mail/reply-now-button.png")
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

  def author_name
    author.name
  end

  def short_author_name
    author.first_name
  end

  def post_url
    url("/posts/#{post.id}")
  end

  def new_message_url
    url("/users/#{author.id}/messages/new")
  end

  def title
    post.subject
  end

  def post_body
    markdown(post.body) rescue "<p>#{post.body}</p>"
  end

  def author_url
    url("/users/#{author.id}")
  end

  def user_name
    user.name
  end
  
end
