class API
  class Replies < Base

    helpers do
      # Returns the reply found with params[:id] or halts with 404
      def find_reply
        @reply ||= Reply.find_by_id(params[:id]) || (halt 404)
      end
    end
  
    # Deletes the reply
    # 
    # Requires ownership
    #
    # Returns 200
    delete "/:id" do
      control_access :owner, find_reply

      find_reply.destroy
      200
    end
    
    # Creates a thank by the current user for the reply
    #
    # Requires community membership
    #
    # Returns the serialized Thank on success
    # Returns 400 on failure
    post "/:id/thank" do
      control_access :community_member, find_reply.community

      thank(Reply, find_reply.id)
    end
    
  end
end
