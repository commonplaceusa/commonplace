class API
  class Announcements < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Announcements.

    helpers do

      # Returns the Postlike class
      def klass
        Announcement
      end
      
      # Set the announcement's attributes using the given request_body
      # 
      # Request params:
      #  subject -
      #  body - 
      #  tag_list -
      # 
      # Returns true on success, false otherwise
      def update_attributes
        find_postlike.update_attributes(
          subject:  request_body["title"],
          body:  request_body["body"],
          tag_list:  request_body["tags"]
          )
      end

    end
    
  end
end
