class RSSFeed < Feed
  validates_uniqueness_of :feed_url
end
