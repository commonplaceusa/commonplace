class TwitterImporter
  require 'twitter'
  
  def self.perform
    Community.find(:all).each do |community|
      community.feeds.find(:all, :conditions => ["twitter_name != ?", "" ]).each do |feed|
        Twitter.user_timeline(feed.twitter_name).each do |tweet|
          # Convert the body to Markdown
          mccbean = McBean.fragment tweet.text
          body = mccbean.to_markdown
          if !TwitterAnnouncement.find_by_subject_and_body_and_feed_id(tweet.user.screen_name,body,feed.id)
            o = TwitterAnnouncement.new()
            o.subject = tweet.user.screen_name
            o.body = body
            o.feed_id = feed.id
            o.url = "http://twitter.com/" + tweet.user.screen_name + "/statuses/" + tweet.id_str
            o.save()
          end
        end
      end
    end
    
  end
  
end