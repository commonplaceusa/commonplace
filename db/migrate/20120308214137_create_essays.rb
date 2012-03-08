class CreateEssays < ActiveRecord::Migration
  def up
    create_table :essays do |t|
      t.string :subject
      t.string :body
      t.integer :user_id
      t.integer :feed_id

      t.timestamps
    end
  end
  
  def down
    drop_table :essays
  end
end
