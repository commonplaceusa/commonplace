class API
  class Events < Base

    helpers do

      def auth(event)
        halt [401, "wrong community"] unless in_comm(event.community.id)
        if (event.owner_type == "Feed")
          event.owner.get_feed_owner(current_account) or current_account.admin
        else
          event.owner == current_account or event.user == current_account or current_account.admin
        end
      end

    end

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

      if auth(event) and event.save
        serialize(event)
      else
        unless auth(event)
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

      if auth(event)
        event.destroy
      else
        [404, "errors"]
      end
    end

    get "/:id" do |id|
      event = Event.find(id)
      halt [401, "wrong community"] unless in_comm(event.community.id)
      serialize event
    end

    post "/:id/replies" do |id|
      event = Event.find(id)
      halt [401, "wrong community"] unless in_comm(event.community.id)
      reply = Reply.new(:repliable => event,
                        :user => current_account,
                        :body => request_body['body'])

      if reply.save
        kickoff.deliver_reply(reply)
        Serializer::serialize(reply).to_json
      else
        [400, "errors"]
      end
    end

	get "/:id/thanks" do |id|
		event = Event.find(id)
		halt [401, "wrong community"] unless in_comm(event.community.id)
		halt [400, "errors: already thanked"] unless event.thanks.index {|t| t.user == current_account } == nil
		thank = Thank.new(:thankable => event,
						:user => current_account)
		if thank.save
		  serialize(event)
		else
		  [400, "errors: #{post.errors.full_messages.to_s}"]
		end
	end

  end
end
