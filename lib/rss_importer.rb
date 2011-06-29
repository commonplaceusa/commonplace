require 'rss'
require 'htmlentities'
require 'resque/plugins/resque_heroku_autoscaler'

class RSSImporter
  extend Resque::Plugins::HerokuAutoscaler

  def self.strip_feedflare(html)
    HTMLEntities.new.decode(html.gsub(/<div class=\"feedflare\">(.*)<\/div>/m, ""))
  end

  def self.perform
    RSSAnnouncement.record_timestamps = false    

    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      begin
        RSS::Parser.parse(open(feed.feed_url).read, false).items.each do |item|
          
          unless RSSAnnouncement.exists?(:url => item.link)
            description = RSSImporter.strip_feedflare(item.description)
            RSSAnnouncement.create(:owner => feed,
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
