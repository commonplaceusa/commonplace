class PostConfirmation < MailBase

  def initialize(post_id)
    @post = Post.find(post_id)
  end

  def subject
    "Your post to CommonPlace"
  end
  
  def post
    @post
  end

  def user
    @user ||= post.user
  end

  def short_poster_name
    user.first_name
  end

  def post_url
    url("/posts/#{post.id}")
  end

  def community
    post.community
  end

  def community_name
    community.name
  end

end
