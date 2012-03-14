class API
  class Events < Postlikes
    
    helpers do

      def auth(event)
        halt [403, "wrong community"] unless in_comm(event.community.id)
        if (event.owner_type == "Feed")
          event.owner.get_feed_owner(current_account) or current_account.admin
        else
          event.owner == current_account or event.user == current_account or current_account.admin
        end
      end
      
      def klass
        Event
      end
      
      def set_attributes(event, request_body)
        event.name = request_body["title"]
        event.description = request_body["body"]
        event.date = request_body["occurs_on"]
        event.start_time = request_body["starts_at"]
        event.end_time = request_body["ends_at"]
        event.venue = request_body["venue"]
        event.address = request_body["address"]
        event.tag_list = request_body["tags"]
      end

    end
    
  end
end
