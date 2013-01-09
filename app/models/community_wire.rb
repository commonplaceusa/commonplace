class CommunityWire

  extend ActsAsApi::Base

  def model_name
    "community_wire"
  end
  
  def initialize(community)
    @community = community
  end

  def events
    @community.events.upcoming.reorder("date ASC").limit(3)
  end

  def transactions
    @community.transactions.reorder("created_at DESC").limit(3)
  end

  def neighborhood
    @community.posts.where(category: 'neighborhood').limit(3)
  end

  def offers
    @community.posts.where(category: 'offers').limit(3)
  end

  def help
    @community.posts.where(category: 'help').limit(3)
  end

  def publicity
    list = (@community.posts.where(category: 'publicity').limit(3) +
      @community.announcements.reorder("GREATEST(replied_at, created_at) DESC").limit(3))
      .sort {|a,b| [b.replied_at, b.created_at].compact.max <=> [a.replied_at, a.created_at].compact.max }.take(3) 
  end
  
  def meetups
    @community.posts.where(category: "meetups").limit(3)
  end

  def group
    GroupPost.order("group_posts.updated_at DESC").includes(:group).
      where(groups: { community_id: @community.id }).limit(3)
  end

  def other
    @community.posts.where(category: 'other').limit(3)
  end

  acts_as_api
  
  api_accessible :default do |t|
    t.add :events
    t.add :neighborhood
    t.add :offers
    t.add :help
    t.add :publicity
    t.add :group
    t.add :announcements
    t.add :other
    t.add :past
    t.add :meetups
    t.add :transactions
  end
  
end
