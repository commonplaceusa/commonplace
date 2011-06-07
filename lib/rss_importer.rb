class RSSImporter
  require 'rss'
  
  def self.perform
    RSSAnnouncement.record_timestamps = false    
    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|

      RSS::Parser.parse(open(feed.feed_url).read, false).items.each do |item|
        
        unless RSSAnnouncement.exists?(:url => item.link)
          begin
            RSSAnnouncement.create(:owner => feed,
                                   :subject => item.title,
                                   :url => item.link,
                                   :community_id => feed.community_id,
                                   :body => McBean.fragment(item.description).to_markdown,
                                   :created_at => item.date.to_datetime,
                                   :updated_at => item.date.to_datetime)
          rescue
          end

        end
      end
    end
    RSSAnnouncement.record_timestamps = true
    
  end
end
