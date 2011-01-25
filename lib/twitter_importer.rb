class TwitterImporter
  require 'twitter'
  
  @start_import_time = Time.new - 60*60*24
  
  def self.perform
    Community.find(:all).each do |community|
      community.feeds.find(:all, :conditions => ["twitter_name != ?", "" ]).each do |feed|
        # Create a TwitterAnnouncement
        twitter_announcement = TwitterAnnouncement.new
        twitter_announcement.subject = "Recent Posts from " + feed.name
        twitter_announcement.body = " "
        twitter_announcement.feed_id = feed.id
        
        twitter_announcement.save
        
        Twitter.user_timeline(feed.twitter_name).each do |tweet|
          # Check the time
          time = Time.zone.parse(tweet.created_at)
          if (time < @start_import_time)
            break
          end
            
          # Import the tweet
          
          # Duplicate Tweets will be weeded out automatically
          t = Tweet.new
          t.screen_name = tweet.user.screen_name
          t.url = "http://twitter.com/" + tweet.user.screen_name + "/statuses/" + tweet.id_str
          t.twitter_announcement_id = twitter_announcement.id
          t.created_at = tweet.created_at

          # Convert the body to Markdown
          mccbean = McBean.fragment tweet.text
          t.body = mccbean.to_markdown

          t.save
        end
        # Delete the TwitterAnnouncement if it is empty
        if twitter_announcement.empty?
          twitter_announcement.destroy
        end
      end
    end
    
  end
  
end