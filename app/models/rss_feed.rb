class RSSFeed

  def initialize(feed)
    @feed = feed
  end

  def items
    if @feed.rss_feed.present?
      RSS::Parser.parse(open(@feed.feed_url).read, false).items
    else
      []
    end
  end

  def update!
    self.items.each do |item|
      begin
        RSSAnnouncement.from_rss_item(item,
                                      :owner => @feed,
                                      :community_id => @feed.community_id).save
      rescue

      end
    end
  end

end
