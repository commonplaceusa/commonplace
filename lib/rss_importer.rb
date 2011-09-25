require 'rss'
require 'htmlentities'

class RSSImporter

  def self.strip_feedflare(html)
    HTMLEntities.new.decode(html.gsub(/<div class=\"feedflare\">(.*)<\/div>/m, ""))
  end

  def self.truncate_feed(feed, source)
    words = feed.split(/\s/)
    word_limit = 148
    if words.size >= word_limit 
      ending = "<a href=\"" + source + "\">...read more</a>"
      words[0,(word_limit-1)].join(' ') + ending
    else 
      feed
    end
  end

  def self.perform
    RSSAnnouncement.record_timestamps = false    

    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      begin
        RSS::Parser.parse(open(feed.feed_url).read, false).items.each do |item|
          
          unless RSSAnnouncement.exists?(:url => item.link)
            description = RSSImporter.strip_feedflare(item.description)
            feedText = McBean.fragment(description).to_markdown
            RSSAnnouncement.create(:owner => feed,
                                   :subject => item.title,
                                   :url => item.link,
                                   :community_id => feed.community_id,
                                   :body => RSSImporter.truncate_feed(feedText, feed.feed_url),
                                   :created_at => item.date.to_datetime,
                                   :updated_at => item.date.to_datetime)
            
          end
        end
      rescue
      end
    end
    RSSAnnouncement.record_timestamps = true
  end
end

# Hack.
class RssImporter < RSSImporter

end
