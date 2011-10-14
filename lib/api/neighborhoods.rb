class API
  class Neighborhoods < Base

    get "/:id/posts" do |id|
      halt [401, "wrong neighborhood"] unless current_user.neighborhood.id == id
      posts = Post.includes(:user).where(:users => {:neighborhood_id => id}).
        reorder("posts.updated_at")

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
