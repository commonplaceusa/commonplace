require 'rss'
require 'htmlentities'

class RssImporter

  def self.strip_feedflare(html)
    HTMLEntities.new.decode(html.gsub(/<div class=\"feedflare\">(.*)<\/div>/m, ""))
  end

  def self.perform
    RssAnnouncement.record_timestamps = false    

    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      begin
        Rss::Parser.parse(open(feed.feed_url).read, false).items.each do |item|
          
          unless RnAnnouncement.exists?(:url => item.link)
            description = RssImporter.strip_feedflare(item.description)
            RssAnnouncement.create(:owner => feed,
                                   :subject => item.title,
                                   :url => item.link,
                                   :community_id => feed.community_id,
                                   :body => McBean.fragment(description).to_markdown,
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
