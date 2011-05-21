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

end
