class API
  class Messages < Base

    post "/:id/replies" do |id|
      message = Message.find(id)
      halt [401, "wrong community"] unless [message.user,message.messagable].include? current_user
      reply = Reply.new(:repliable => message,
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
