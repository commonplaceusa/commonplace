class GroupPostBodyIsText < ActiveRecord::Migration
  def self.up
    change_column :group_posts, :body, :text
  end

  def self.down
    change_column :group_posts, :body, :string
  end
end
