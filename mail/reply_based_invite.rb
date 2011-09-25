class ReplyBasedInvite < MailBase
   
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def subject
    "The #{community_name} CommonPlace community helped you this past week. Give back by inviting neighbors to the network."
  end

  def user
    @user
  end

  def short_user_name
    user.first_name
  end
 
  def community
    @user.community
  end

  def community_name
    community.name
  end

  def tag
    'reply_based_invite'
  end

  
