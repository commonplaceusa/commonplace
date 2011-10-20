
class RSSImporter
  def self.perform
    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      Exceptional.rescue do
        feed.rss_feed.update!
      end
    end
  end
end

# Hack.
class RssImporter < RSSImporter

end
