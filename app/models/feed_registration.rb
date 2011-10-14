class FeedRegistration

  def initialize(feed)
    @feed = feed
  end

  attr_reader :feed

  def self.find_or_create(options)
    feed = Feed.find_by_id(options[:id]) || 
      Feed.new(:community => options[:community], :user => options[:user])
    
    new(feed)
  end

  def attributes=(params)
    feed.attributes=(params)
  end

  def update_attributes(params)
    feed.update_attributes(params)
  end

  def save
    if feed.save
      feed.owners << feed.user
      kickoff.deliver_feed_owner_welcome(feed)
      true
    else
      false
    end
  end

  def invite_subscribers(emails)
    kickoff.deliver_feed_invite(emails, feed)
  end

  def to_param
    feed.id.to_s
  end

  def avatar_url(style = nil)
    feed.avatar_url(style)
  end

  def has_avatar?
    feed.avatar?
  end

  def kickoff
    @kickoff || KickOff.new
  end
end
