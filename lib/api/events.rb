class API
  class Events < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Events.
    
    helpers do

      def find_event
        @event = Event.find_by_id(params[:id]) || (halt 404)
      end
      
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
    # Requires community membership
    post "/:id/checkins" do
      control_access :community_member, find_event.community

      EventCheckin.create(:user => current_user, :event => find_event)
      200
    end

    # Creates a note on the event by a user (different from a reply)
    #
    # Params
    #  body - the text of the note
    #
    # Requires community membership
    post "/:id/notes" do
      control_access :community_member, find_event.community
      event_note = EventNote.create(
        :user => current_user, 
        :event => find_event, 
        :body => request_body["body"]
        )
      serialize(event_note)
    end

    # Gets the list of notes posted on the event
    #
    # Requires community membership
    get "/:id/notes" do
      control_access :community_member, find_event.community
      serialize(EventNote.where(:event_id => find_event.id))
    end
    
  end
end
