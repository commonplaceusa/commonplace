class AddNeighborhoodIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :neighborhood_id, :integer
    Post.all.each do |post|
      post.neighborhood_id = post.user.neighborhood_id
      post.save
    end
  end

  def self.down
    remove_column :posts, :neighborhood_id
  end
end
