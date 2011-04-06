class RSSImporter
  require 'rss'
  
  def self.perform
    
    subject_tag     = CONFIG['rss_subject_tag'] || 'title'
    body_tag        = CONFIG['rss_body_tag'] || 'description'
    story_url_tag   = CONFIG['rss_story_url_tag'] || 'link'
    
    
    Feed.find(:all, :conditions => ["feed_url != ?", "" ]).each do |feed|
      RSS::Parser.parse(open(feed.feed_url).read, false).items.each do |item|
        
        # If the item hasn't been added yet
        unless RSSAnnouncement.exists?(:url => item.send(story_url_tag))
            
          # Pull the values from the Item object, using arbitrary tag names 
          RSSAnnouncement.create(:owner => feed,
                                 :subject => item.send(subject_tag),
                                 :url => item.send(story_url_tag),
                                 :community_id => feed.community_id,
                                 :body => McBean.fragment(item.send(body_tag)).to_markdown)
          
        end
      end
      
    end
    
  end
end
