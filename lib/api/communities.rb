class API
  class Communities < Base

    before "/:community_id/*" do |community_id, stuff|
      unless current_account.community.id == community_id || current_account.admin
        [401, "wrong community"]
      end
    end

    helpers do

      def search(klass, params, community_id)
        search = Sunspot.search(klass) do
          keywords phrase(params["query"])
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end
      
      def chronological(klass, params, community_id)
        search = Sunspot.search(klass) do
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1, :per_page => params["limit"])
          with(:community_id, community_id)
        end
        serialize(search)
      end

      def event_search(params, community_id)
        search = Sunspot.search(Event) do
          order_by(:date, :desc)
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      def phrase(string)
        string.split('"').each_with_index.map { |object, i|
          i.odd? ? object : object.split(" ")
        }.flatten
      end

    end

    post "/:community_id/posts" do |community_id|
      post = Post.new(:user => current_account,
                      :community_id => community_id,
                      :subject => request_body['title'],
                      :body => request_body['body'])
      if post.save
        kickoff.deliver_post(post)
        serialize(post)
      else
        [400, "errors"]
      end
    end

    post "/:community_id/announcements" do |community_id|
      announcement = Announcement.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community_id => community_id,
                                      :group_ids => request_body["groups"])

      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    post "/:community_id/events" do |community_id|
      event = Event.new(:owner => current_account,
                        :name => request_body['title'],
                        :description => request_body['about'],
                        :date => request_body['date'],
                        :start_time => request_body['start'],
                        :end_time => request_body['end'],
                        :venue => request_body['venue'],
                        :address => request_body['address'],
                        :tag_list => request_body['tags'],
                        :community_id => community_id,
                        :group_ids => request_body['groups']
      )
      if event.save
        serialize(event)
      else
        [400, "errors"]
      end
    end

    get "/:community_id/posts" do |community_id|
      last_modified_by_updated_at(Post)

      if params["query"].present?
        search(Post, params, community_id)
      else
        serialize(paginate(Community.find(community_id).posts.includes(:user, :replies)))
      end
    end

    get "/:community_id/events" do |community_id|
      last_modified([Event.unscoped.reorder("updated_at DESC").
                       select('updated_at').
                       first.try(&:updated_at),
                     Date.today.beginning_of_day].compact.max)

      if params["query"].present?
        event_search(params, community_id) do |search|
          search.with(:date).greater_than(Time.now.beginning_of_day)
        end
      else
        serialize(paginate(Community.find(community_id).events.upcoming.
                             includes(:replies).reorder("date ASC")))
      end
    end

    get "/:community_id/announcements" do |community_id|
      last_modified_by_updated_at(Announcement)

      if params["query"].present?
        search(Announcement, params, community_id)
      else
        serialize(paginate(Community.find(community_id).announcements.
                             includes(:replies, :owner).
                             reorder("updated_at DESC")))
      end
    end

    get "/:community_id/group_posts" do |community_id|
      last_modified_by_updated_at(GroupPost)

      if params["query"].present?
        search(GroupPost, params, community_id)
      else
        serialize(paginate(GroupPost.order("group_posts.updated_at DESC").
                             includes(:group, :user).
                             where(:groups => {:community_id => community_id})))
      end
    end

    get "/:community_id/feeds" do |community_id|
      last_modified_by_updated_at(Feed)

      if params["query"].present?
        search(Feed, params, community_id)
      else
        scope = Community.find(community_id).feeds.reorder("name ASC")
        serialize(paginate(scope))
      end
    end

    get "/:community_id/groups" do |community_id|
      last_modified_by_updated_at(Group)

      if params["query"].present?
        search(Group, params, community_id)
      else
        serialize(paginate(Community.find(community_id).groups.reorder("name ASC")))
      end
    end

    get "/:community_id/users" do |community_id|
      last_modified_by_updated_at(User)

      if params["query"].present?
        search(User, params, community_id)
      else
        scope = Community.find(community_id).users.reorder("last_name ASC, first_name ASC")
        serialize(paginate(scope))
      end
    end

    get "/:community_slug/user_count" do |community_slug|
      serialize(Community.find_by_slug(community_slug).users.count)
    end


    get "/:community_id/group-like" do |community_id|
      # only search
      halt [200, {}, "[]"] if params["query"].blank?

      search([Feed, Group, User], params, community_id)
    end

    get "/:community_id/post-like" do |community_id|
      if params["query"].present?
        search([Announcement, Event, Post, GroupPost], params, community_id)
      else
        chronological([Announcement, Event, Post, GroupPost], params, community_id)
      end
    end


    post "/:community_id/add_data_point" do |community_id|
      num = params[:number]
      zip_code = User.find(current_account.id).community.zip_code
      if num.include? "-"
        odds = false
        evens = false
        all = true
        if num.include? "O"
          odds = true
          all = false
          num = num.gsub("O", "")
        elsif num.include? "E"
          evens = true
          all = false
          num = num.gsub("E", "")
        end

        range = num.split("-")
        (range[0].to_i..range[1].to_i).each do |n|
          if (odds and (n % 2 == 1)) or (evens and (n % 2 == 0)) or all
            data_point = OrganizerDataPoint.new
            data_point.organizer_id = current_account.id
            data_point.address = "#{n} #{params[:address]} #{zip_code}"
            data_point.status = params[:status]
            data_point.save
          end
        end
      else
        data_point = OrganizerDataPoint.new
        data_point.organizer_id = current_account.id
        data_point.address = "#{num} #{params[:address]} #{zip_code}"
        data_point.status = params[:status]
        data_point.save
        data_point.generate_point
      end
      [200, "OK"]
    end


    get "/:community_id/registration_points" do |community_id|
      headers 'Access-Control-Allow-Origin' => '*'
      community = Community.find(community_id)
      callback = params.delete("callback")
      unless callback.present?
        serialize(community.users.map &:generate_point)
      else
        jsonp(callback, serialize(community.users.map &:generate_point))
      end
    end

    get "/:community_id/data_points" do |community_id|
      headers 'Access-Control-Allow-Origin' => '*'
      community = Community.find(community_id)
      callback = params.delete("callback")
      unless callback.present?
        if params[:top]
          serialize(community.organizers.map(&:organizer_data_points).flatten.uniq { |p| p.address }.select { |p| p.present? })
        else
          serialize(community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? })
        end
      else
        if params[:top]
          jsonp(callback, serialize(community.organizers.map(&:organizer_data_points).flatten.uniq { |p| p.address }.select { |p| p.present? }))
        end
        jsonp(callback, serialize(community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }))
      end
    end

    post "/:community_id/invites" do |community_id|
      kickoff.deliver_user_invite(request_body['emails'], current_account, request_body['message'])
      [200, {}, ""]
    end

  end
end
