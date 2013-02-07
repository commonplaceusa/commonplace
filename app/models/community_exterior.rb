class CommunityExterior

  extend ActsAsApi::Base

  def model_name
    "community_exterior"
  end

  def initialize(community)
    @community = community
  end

  def id
    @community.id
  end

  def slug
    @community.slug
  end

  def name
    @community.name
  end

  def interests
    $interests
  end

  def goods
    $goods
  end

  def skills
    $skills
  end

  def has_residents_list
    @community.feature_switches[:find_my_neighbor]
  end

  def grouplikes
    combo = [@community.feeds.featured, @community.groups].flatten.sort_by do |grouplike|
      grouplike.subscribers.count
    end
    combo.reverse.map do |grouplike|
      {
        "id" => grouplike.id,
        "name" => grouplike.name,
        "avatar_url" => (grouplike.class == Feed) ? grouplike.avatar_url(:normal) : grouplike.avatar_url,
        "about" => grouplike.about,
        "schema" => (grouplike.class == Feed) ? "feeds" : "groups"
      }
    end
  end

  def feeds
    @community.feeds.featured.map do |feed|
      {
        "id" => feed.id,
        "name" => feed.name,
        "avatar_url" => feed.avatar_url(:normal)
      }
    end
  end

  def groups
    @community.groups.map do |group|
      {
        "id" => group.id,
        "name" => group.name,
        "avatar_url" => group.avatar_url,
        "about" => group.about
      }
    end
  end

  def referral_sources
    if @community.slug == "HarvardNeighbors"
      [
        "Current Faculty",
        "Current Staff",
        "Retiree",
        "Visiting Scholar/Researcher",
        "Post-Doc Fellow/Program Fellow",
        "Spouse/Partner"
      ]
    else
      [
        "Received a postcard in my mailbox",
        "Received an email from Ricky Porco",
        "Heard about it from a friend or neighbor",
        "Heard about it in a news story",
        "Heard about it through 50 Reasons #{name} is Awesome",
        "Other"
      ]
    end
  end

  def links
    {
      "self" => "/registration/#{id}",
      "tour" => "/#{slug}/registration",
      "learn_more" => "/#{slug}/about",
      "facebook_login" => "/users/auth/facebook",
      "registration" => {
        "validate" => "/registration/#{id}/validate",
        "new" => "/registration/#{id}/new",
        "avatar" => "/account/avatar",
        "facebook" => "/registration/#{id}/facebook",
        "residents" => "/communities/#{id}/residents",
        "nominate_civic_hero" => "/registration/#{id}/civic_hero_nomination",
        "apply_civic_leader" => "/registration/#{id}/civic_leader_application"
      }
    }
  end

  def statistics
    {
      "created_at" => @community.created_at.strftime("%B %Y"),
      "neighbors" => @community.users.count,
      "feeds" => @community.feeds.count,
      "postlikes" => @community.posts.count + @community.events.count + @community.announcements.count + @community.group_posts.count
    }
  end

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add :slug
    t.add :name
    t.add :interests
    t.add :goods
    t.add :skills
    t.add :referral_sources
    t.add :feeds
    t.add :groups
    t.add :links
    t.add :statistics
    t.add :has_residents_list
  end

end
