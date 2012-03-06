class API
  class Neighborhoods < Unauthorized

    get "/:id/posts" do |id|
      halt [401, "wrong neighborhood"] unless current_user.neighborhood.id == id
      posts = Post.includes(:user).where(:users => {:neighborhood_id => id}).
        reorder("posts.replied_at")

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
