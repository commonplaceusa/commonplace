class AddResidents < ActiveRecord::Migration

  def up
    create_table :residents do |t|
      t.string :first_name
      t.string :last_name
      t.text :metadata
      t.integer :user_id
      t.integer :community_id
    end
  end

  def down
    drop_table :residents
  end
end
