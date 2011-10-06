class API
  class Search < Base

    helpers do
      
      def search(klass, params, community_id)
        search = Sunspot.search(klass) do
          keywords phrase(params["query"])
          paginate(:page => params["page"])
          with(:community_id, community_id)
        end
        serialize(search)
      end

      def phrase(string)
        string.split('"').each_with_index.map { |object, i|
          i.odd? ? object : object.split(" ")
        }.flatten
      end

    end

    get "/:id/feeds" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Feed, params, community_id)
    end

    get "/:id/groups" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Group, params, community_id)
    end

    get "/:id/users" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(User, params, community_id)
    end

    get "/:id/group-like" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search([Feed, Group, User], params, community_id)
    end

    get "/:id/announcements" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Announcement, params, community_id)
    end

    get "/:id/events" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Event, params, community_id)
    end

    get "/:id/posts" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Post, params, community_id)
    end

    get "/:id/group-posts" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(GroupPost, params, community_id)
    end

    get "/:id/post-like" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search([Announcement, Event, Post, GroupPost], params, community_id)
    end

  end
end
