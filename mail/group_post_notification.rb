class GroupPostNotification < PostNotification

  self.template = PostNotification.template

  def initialize(post_id, user_id)
    @post, @user = GroupPost.find(post_id), User.find(user_id)
  end

  def group_name
    group.name
  end

  def group
    post.group
  end
    
  def subject
    "#{author_name} posted to The #{community_name} #{group_name} Group on CommonPlace"
  end

  def reply_to
    "reply+group_post_#{post.id}@ourcommonplace.com"
  end

  def post_url
    show_group_post_url(post.id)
  end

  def tag
    'group_post'
  end

end
