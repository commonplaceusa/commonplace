class AddThanks < ActiveRecord::Migration
  def up
    create_table :thanks do |t|
      t.integer :user_id
      t.integer :thankable_id
      t.string :thankable_type

      t.timestamps
    end
    
  end
  
  def down
    drop_table :thanks
  end
end
