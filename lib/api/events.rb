class API
  class Events < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Events.
    
    helpers do
      
      # Returns the Postlike class
      def klass
        Event
      end
      
      # Set the event's attributes using the given request_body
      # 
      # Request params:
      #   title -
      #   body - 
      #   occurs_on -
      #   starts_at -
      #   ends_at -
      #   venue - 
      #   address -
      #   tags -
      # Returns true on success, false otherwise      
      def update_attributes
        find_postlike.update_attributes(
          name:  request_body["title"],
          description:  request_body["body"],
          date:  request_body["occurs_on"],
          start_time:  request_body["starts_at"],
          end_time:  request_body["ends_at"],
          venue:  request_body["venue"],
          address:  request_body["address"],
          tag_list:  request_body["tags"])
      end

    end

    # Records the that the current user checked in to this event
    #
    # Requires authorization
    post "/:id/checkins" do
      event = Event.find_by_id(params[:id]) || (halt 404)
      EventCheckin.create(:user => current_user, :event => event)
      200
    end
    
  end
end
