class API
  class Neighborhoods < Base

    get "/:id/posts" do |id|
      posts = Post.includes(:user).where(:users => {:neighborhood_id => id})

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
