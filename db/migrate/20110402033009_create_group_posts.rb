class CreateGroupPosts < ActiveRecord::Migration
  def self.up
    create_table :group_posts do |t|
      t.string :subject
      t.string :body
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_posts
  end
end
