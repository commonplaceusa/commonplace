class Activity

  extend ActsAsApi::Base
  
  def model_name
    "activity"
  end
  
  def initialize(user)
    @user = user
    @community = @user.community
  end
  
  def both(models)
    {
      "all" => models.count,
      "week" => models.this_week.count
    }
  end
  
  def created_at
    @user.created_at.strftime "%B %Y"
  end
  
  def posts
    both @user.posts
  end
  
  def credits
    {
      "all" => @user.all_cpcredits,
      "week" => @user.weekly_cpcredits
    }
  end
  
  def thanks
    both @user.thanks
  end
  
  def replies
    {
      "all" => @user.replies_received.count,
      "week" => @user.replies_received_this_week.count
    }
  end
  
  def received_thanks
    {
      "all" => @user.thanks_received.count,
      "week" => @user.thanks_received_this_week.count
    }
  end
  
  def invites
    {
      "all" => @user.all_invitations.count,
      "week" => @user.invitations_this_week.count
    }
  end
  
  def community_users
    both @community.users
  end
  
  def community_posts
    both @community.posts
  end
  
  def community_replies
    {
      "all" => @community.total_replies,
      "week" => @community.replies_this_week
    }
  end
  
  def households
    @community.households
  end
  
  acts_as_api
  
  api_accessible :default do |t|
    t.add :posts
    t.add :credits
    t.add :thanks
    t.add :replies
    t.add :received_thanks
    t.add :invites
    t.add :community_users
    t.add :community_posts
    t.add :community_replies
    t.add :households
    t.add :created_at
  end
  
end
