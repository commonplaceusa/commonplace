class CreateWarnings < ActiveRecord::Migration
  def change
    create_table :warnings do |t|
      t.integer :user_id
      t.integer :warnable_id
      t.string :warnable_type

      t.timestamps
    end
  end
end
