class GroupPostNotification < PostNotification

  def initialize(post_id, user_id)
    @post, @user = GroupPost.find(post_id), User.find(user_id)
  end

  def group_name
    group.name
  end

  def group
    post.group
  end
    
  def post
    @post
  end

  def subject
    "#{poster_name} just posted to #{group_name}"
  end

  def poster
    @post.user
  end

  def user
    @user
  end

  def poster_name
    poster.name
  end

  def community_name
    community.name
  end

  def community
    user.community
  end

  def short_poster_name
    poster.first_name
  end

  def post_url
    url("/group_posts/#{post.id}")
  end

  def post_subject
    post.subject
  end
  
  def post_body
    markdown(post.body)
  end

  def poster_avatar_url
    asset_url(poster.avatar_url(:thumb))
  end

  def group_avatar_url
    asset_url(group.avatar_url(:thumb))
  end
  
  def user_name
    user.name
  end

end
