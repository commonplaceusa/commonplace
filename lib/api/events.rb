class API
  class Events < Base
    put "/:id" do |id|
      event = Event.find(id)
      unless event.present?
        [404, "errors"]
      end

      event.name = request_body['title']
      event.description = request_body['body']
      event.date = request_body['occurs_on']
      event.start_time = request_body['starts_at']
      event.end_time = request_body['ends_at']
      event.venue = request_body['venue']
      event.address = request_body['address']
      event.tag_list = request_body['tags']

      # TODO: This should deal with feeds...
      if (event.user == current_account or current_account.admin) and event.save
        serialize(event)
      else
        unless (event.owner == current_account or current_account.admin)
          [401, "unauthorized"]
        else
          [500, "could not save"]
        end
      end
    end

    delete "/:id" do |id|
      event = Event.find(id)
      unless event.present?
        [404, "errors"]
      end

      if (event.owner == current_account or current_account.admin)
        event.destroy
      else
        [404, "errors"]
      end
    end

    get "/:id" do |id|
      serialize Event.find(id)
    end

    post "/:id/replies" do |id|
      reply = Reply.new(:repliable => Event.find(id),
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
