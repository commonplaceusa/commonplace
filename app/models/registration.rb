class Registration

  def initialize(user)
    @user = user
    if user.calculated_cp_credits.nil?
      user.calculated_cp_credits = 0
    end
  end

  attr_reader :user

  def has_avatar?
    user.avatar?
  end

  def save
    user.save
  end

  def attributes=(params)
    user.attributes = params
  end

  def update_attributes(params)
    user.update_attributes(params)
  end

  def first_name
    user.first_name
  end

  def from_facebook?
    user.is_facebook_user
  end

  def avatar_url(type = nil)
    user.avatar_url(type)
  end

  def add_feeds(feed_ids)
    user.feed_ids = feed_ids
  end

  def add_groups(group_ids)
    user.group_ids = group_ids
  end

  def community
    user.community
  end

  def referral_sources
    [
      "Flyer at my door",
      "Someone knocked on my door",
      "In a meeting with #{community.organizer_name}",
      "At a table or booth at an event",
      "In an email",
      "On Facebook or Twitter",
      "On another website",
      "In the news",
      "Word of mouth",
      "Phone Call with Julia Campbell",
      "Other"
    ]
  end
end
