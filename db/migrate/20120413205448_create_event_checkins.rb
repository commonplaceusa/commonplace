class CreateEventCheckins < ActiveRecord::Migration
  def change
    create_table :event_checkins do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
