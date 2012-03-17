class API
  class Posts < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Posts.

    helpers do

      # Returns the Postlike klass
      def klass
        Post
      end    

      # Set the post's attributes using the given request_body
      # 
      # Request params:
      #  subject -
      #  body - 
      #  category -
      # 
      # Returns true on success, false otherwise
      def update_attributes
        find_postlike.update_attributes(
          subject:  request_body["title"],
          body:  request_body["body"],
          category:  request_body["category"]
          )
      end

    end
    
  end
end
