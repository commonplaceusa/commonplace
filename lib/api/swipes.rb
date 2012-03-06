class API
  class Swipes < Base
  
    # Creates a swipe for the user at the feed
    #
    # Returns the serialized Swipe
    post "/:user_id/at/:feed_id" do |user_id, feed_id|
      control_access :public
      
      swipe = Swipe.new(:feed => Feed.find_by_id(feed_id),
                        :user => User.find_by_id(user_id),
                        :feed_pwd => params["feed_pwd"])
      
      swipe.save
      serialize swipe
    end
    
  end
end
