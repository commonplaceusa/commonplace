class API
  class GroupPosts < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with GroupPosts

    helpers do
      
      # Returns the Postlike class
      def klass
        GroupPost
      end

      # Set the group post's attributes using the given request_body
      # 
      # Request params:
      #   title -
      #   body - 
      #
      # Returns true on success, false otherwise
      def update_attributes
        find_postlike.update_attributes(
          subject: request_body["title"],
          body: request_body["body"])
      end

    end
    
  end
end
