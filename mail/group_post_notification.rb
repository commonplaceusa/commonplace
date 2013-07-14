class GroupPostNotification < PostNotification

  self.template_file = PostNotification.template_file

  def initialize(post_id, user_id)
    @post, @user = GroupPost.find(post_id), User.find(user_id)
  end

  def group_name
    group.name
  end

  def group
    post.group
  end

  def author
    @post.owner
  end

  def subject
    "#{author_name} just posted to #{group_name}"
  end

  def reply_to
    "reply+group_post_#{post.id}@ourcommonplace.com"
  end

  def post_url
    show_group_post_url(post.id)
  end

  def has_avatar
    true
  end

  def author_avatar_url
    asset_url(group.avatar_url(:thumb))
  end

  def tag
    'group_post'
  end

  def deliver?
    false
  end

end
