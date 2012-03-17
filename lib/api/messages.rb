class API
  class Messages < Base

    helpers do 
      # Finds the message by params[:id] or halts with 404
      def find_message
        @message ||= Message.find_by_id(params[:id]) || (halt 404)
      end
    end

    # Creates a reply to the message
    #
    # Requires thread membership
    #
    # Request params:
    #   body - The reply body
    # 
    # Returns the serialized messag on success
    # Kicks off a message reply notification on success
    # Returns 400 on failure
    post "/:id/replies" do |id|
      control_access :thread_member, find_message

      reply = Reply.new(:repliable => find_message,
                        :user => current_account,
                        :body => request_body['body'])

      if reply.save
        kickoff.deliver_reply(reply)
        Serializer::serialize(reply).to_json
      else
        [400, "errors"]
      end
    end

  end
end
