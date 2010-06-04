class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.text :body, :null => false
      t.integer :post_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
