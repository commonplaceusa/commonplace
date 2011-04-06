class TwitterImporter
  require 'twitter'
  
  def self.perform
    Feed.find(:all, :conditions => ["twitter_name != ?", ""]).each do |feed|
      
      Twitter.user_timeline(feed.twitter_name).each do |tweet|

      
        unless TwitterAnnouncement.exists?(:tweet_id => tweet.id.to_s)
          
          TwitterAnnouncement.create(:owner => feed,
                                     :community_id => feed.community_id,
                                     :subject => "Post from #{feed.name}'s Twitter",
                                     :body => tweet.text,
                                     :tweet_id => tweet.id.to_s)
        end
      end
    end
  end
end
