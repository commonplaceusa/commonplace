class TwitterAnnouncement < Announcement
  has_many :tweets
  
  def empty?
    Tweet.find_by_twitter_announcement_id(self.id) == nil
  end
  
end
