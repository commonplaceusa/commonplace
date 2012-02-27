class CreateSwipes < ActiveRecord::Migration
  def up
    create_table :swipes do |t|
    
      t.integer :feed_id
      t.integer :user_id
      t.timestamps
      
    end
    
    add_column :users, :card_id, :integer
    
    add_column :feeds, :password, :string
    
  end

  def down
    remove_column :users, :card_id
    
    remove_column :feeds, :password
    
    drop_table :swipes
    
  end
end
