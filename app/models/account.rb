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

  def posts
    @user.posts.map &:id
  end

  def events
    @user.events.map &:id
  end

end
