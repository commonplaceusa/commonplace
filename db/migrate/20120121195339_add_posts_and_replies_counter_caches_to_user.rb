class AddPostsAndRepliesCounterCachesToUser < ActiveRecord::Migration
  def change
    add_column :users, :replies_count, :integer
    add_column :users, :posts_count, :integer
  end
end
