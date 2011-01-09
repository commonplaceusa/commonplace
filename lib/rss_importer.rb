class RSSImporter
  require 'rss'
  
  def self.perform
    
    subject_tag     = CONFIG['rss_subject_tag'] || 'title'
    body_tag        = CONFIG['rss_body_tag'] || 'description'
    story_url_tag   = CONFIG['rss_story_url_tag'] || 'link'
    
    
    Community.find(:all).each do |community|
      community.feeds.find_all_by_type("RSSFeed").each do |feed|
        rss = RSS::Parser.parse(open(feed.feed_url).read, false)
        rss.items.each { |i|
          # Determine if the item has been added yet
          
          # Pull the values from the Item object, using arbitrary tag names (accessors)
          subject = i.send(subject_tag)
          # Convert the body to Markdown
          mccbean = McBean.fragment i.send(body_tag)
          body = mccbean.to_markdown
          
          feed_id = feed.id
          url     = i.send(story_url_tag)
          
          if !RSSAnnouncement.find_by_subject_and_body_and_feed_id(subject,body,feed_id)
            o = RSSAnnouncement.new()
            o.subject = subject
            o.body = body
            o.feed_id = feed_id
            o.url = url
            o.save()
          end
          
        }
      end
    end
    
  end
  
end
