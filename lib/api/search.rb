class API
  class Search < Base

    helpers do
      
      def search(klass, params)
        search = Sunspot.search(klass) do
          keywords params["query"].split(" ")
          paginate(:page => params["page"])
        end
        serialize(search.results)
      end

    end

    get "/" do
      halt [200, {}, "[]"]
    end

    get "/feeds" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Feed, params)
    end

    get "/groups" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Group, params)
    end

    get "/users" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(User, params)
    end

    get "/group-like" do
      halt [200, {}, "[]"] if params["query"].blank?

      search([Feed, Group, User], params)
    end

    get "/announcements" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Announcement, params)
    end

    get "/events" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Event, params)
    end

    get "/posts" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Post, params)
    end

    get "/group-posts" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(GroupPost, params)
    end

    get "/post-like" do
      halt [200, {}, "[]"] if params["query"].blank?

      search([Announcement, Event, Post, GroupPost], params)
    end

  end
end
