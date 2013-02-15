class Account
  def initialize(user)
    @user = user
  end

  attr_accessor :user

  def feed_subscriptions
    @user.subscriptions.map &:feed_id
  end

  def mets
    @user.mets.map &:wanted_id
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
    @user.direct_event_ids + @user.managable_feeds.flat_map {|f| f.event_ids }
  end

  def announcements
    @user.announcement_ids + @user.managable_feeds.flat_map {|f| f.announcement_ids }
  end

  def group_posts
    GroupPost.find_all_by_user_id(@user.id).map &:id
  end

  def neighborhood
    @user.neighborhood_id
  end

  def feeds
    @user.managable_feeds.map do |feed|
      {"name" => feed.name,
        "id" => feed.id,
        "community" => feed.community.name,
        "slug" => feed.slug.blank? ? feed.id : feed.slug
      }
    end
  end

  # Eventually we will recommend by location or by interests, currently this
  # just returns all the events in the community.
  def recommendations
    @user.community.events.upcoming.where(:owner_type => "Feed").map do |e|
      EventRecommendation.new(e)
    end
  end

  def method_missing(method, *args)
    @user.send(method, *args)
  end
end
