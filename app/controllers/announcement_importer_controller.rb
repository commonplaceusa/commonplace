class AnnouncementImporterController < ApplicationController
  require 'outside_in'
  
  def self.perform
    OutsideIn.key = CONFIG['outside_in_key']
    OutsideIn.secret = CONFIG['outside_in_secret']
    count = 0
    
    Community.find(:all).each do |community|
      OutsideIn::Story.for_zip_code(community.zip_code)[:stories].each do |story|
        o = OutsideAnnouncement.new()
        o.subject = story.title
        o.body = story.summary
        o.feed_id = Feed.find_or_create_by_name_and_website_and_community_id(story.feed_title, story.feed_url, community).id
        o.url = story.story_url
        count += 1
        o.save()
      end
    end
    
  end
  
end
