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
    @community.posts.where(category: 'publicity').limit(3)
  end

  def group
    GroupPost.order("group_posts.updated_at DESC").includes(:group).
      where(groups: { community_id: @community.id }).limit(3)
  end

  def announcements
    @community.announcements.reorder("updated_at DESC").limit(3)
  end

  def other
    @community.posts.where(category: 'other').limit(3)
  end

  def past
    other_posts = [:events, :neighborhood, :offers, :help, 
      :publicity, :group, :announcements, :other].flat_map {|m| self.send(m) }
    id = @community.id
    past_posts = Sunspot.search([Announcement, Event, GroupPost, Post]) do 
      order_by(:created_at, :desc)
      paginate(page: 1, per_page: other_posts.size + 3)
      with(:community_id, id)
    end

    # return past_posts without posts that will be shown in a previous group
    past_posts.results - other_posts 
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
  end
  
end
