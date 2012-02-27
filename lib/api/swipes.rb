class API
  class Swipes < Unauthorized
  
    post "/:user_id/at/:feed_id" do |user_id, feed_id|
      swipe = Swipe.new(:feed => Feed.find_by_id(feed_id),
                        :user => User.find_by_id(user_id),
                        :feed_pwd => params["feed_pwd"])
      
      swipe.save
      serialize swipe
    end
    
  end
end
