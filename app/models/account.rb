class Account
  def initialize(user)
    @user = user
  end

  attr_accessor :user

  def feed_subscriptions
    @user.subscriptions.map &:feed_id    
  end

  def group_subscriptions
    @user.memberships.map &:group_id
  end

  def avatar_url(style=nil)
    @user.avatar_url(style)
  end

  def id
    @user.id
  end

  def is_admin
    @user.admin?
  end

  def accounts
    [@user] + @user.managable_feeds
  end

  def short_name
    @user.first_name
  end

  def email
    @user.email
  end

  def posts
    @user.posts.map &:id
  end

  def events
    Event.find_all_by_owner_id(@user.id).map &:id
  end

  def announcements
    @user.announcements.map &:id
  end

  def group_posts
    GroupPost.find_all_by_user_id(@user.id).map &:id
  end

  def neighborhood
    @user.neighborhood_id
  end
end
