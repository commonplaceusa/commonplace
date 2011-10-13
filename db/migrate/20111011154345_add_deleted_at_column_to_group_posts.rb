class AddDeletedAtColumnToGroupPosts < ActiveRecord::Migration
  def change

    add_column :group_posts, :deleted_at, :datetime
  end
end
