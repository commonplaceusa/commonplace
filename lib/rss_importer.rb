
class RSSImporter
  def self.perform
    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      unless (feed.feed_url =~ URI::regexp).nil?
        if feed.feed_url.match /^http/
          begin
            feed.rss_feed.update!
          rescue
          end
        end
      end
    end
  end
end

# Hack.
class RssImporter < RSSImporter

end
