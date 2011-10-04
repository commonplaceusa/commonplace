class API
  class Messages < Base

    post "/:id/replies" do |id|
      reply = Reply.new(:repliable => Message.find(id),
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
