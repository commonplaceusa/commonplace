class API
  class Communities < Base

    post "/:id/posts" do |community_id|
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

    post "/:id/announcements" do
      announcement = Announcement.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community_id => params[:id],
                                      :group_ids => request_body["groups"])

      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    post "/:id/group_posts" do
      group_post = GroupPost.new(:group => Group.find(request_body['group']),
                                 :subject => request_body['title'],
                                 :body => request_body['body'],
                                 :user => current_account)
      if group_post.save
        kickoff.deliver_group_post(group_post)
        serialize(group_post)
      else
        [400, "errors"]
      end
    end



    get "/:id/posts" do |id|
      last_modified_by_updated_at(Post)

      serialize(paginate(Community.find(id).posts.includes(:user, :replies)))
    end


    get "/:id/events" do |id|
      last_modified([Event.unscoped.reorder("updated_at DESC").
                     select('updated_at').
                     first.try(&:updated_at),
                     Date.today.beginning_of_day].compact.max)

      serialize(paginate(Community.find(id).events.upcoming.
                         includes(:replies).reorder("date ASC")))
    end

    get "/:id/announcements" do |id|
      last_modified_by_updated_at(Announcement)

      serialize(paginate(Community.find(id).announcements.
                         includes(:replies, :owner).
                         reorder("updated_at DESC")))
    end

    get "/:id/group_posts" do |id|
      last_modified_by_updated_at(GroupPost)

      serialize(paginate(GroupPost.order("group_posts.updated_at DESC").
                         includes(:group, :user, :replies => :user).
                         where(:groups => {:community_id => id})))
    end

    get "/:id/feeds" do |id|
      last_modified_by_updated_at(Feed)

      serialize(paginate(Community.find(id).feeds))
    end

    get "/:id/groups" do |id|
      last_modified_by_updated_at(Group)

      serialize(paginate(Community.find(id).groups))
    end

    get "/:id/users" do |id|
      last_modified_by_updated_at(User)

      serialize(paginate(Community.find(id).users.includes(:feeds, :groups)))
    end



    post "/:id/add_data_point" do |id|
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


    get "/:id/registration_points" do |id|
      headers 'Access-Control-Allow-Origin' => '*'
      community = Community.find(id)
      callback = params.delete("callback")
      unless callback.present?
        NO_CALLBACK
      else
        jsonp(callback, serialize(community.users.map &:generate_point))
      end
    end
    
    get "/:id/data_points" do |id|
      headers 'Access-Control-Allow-Origin' => '*'
      community = Community.find(id)
      callback = params.delete("callback")
      unless callback.present?
        NO_CALLBACK
      else
        if params[:top]
          jsonp(callback, serialize(community.organizers.map(&:organizer_data_points).flatten.uniq { |p| p.address }.select { |p| p.present? }))
        end
        jsonp(callback, serialize(community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }))
      end
    end
    
  end
end
