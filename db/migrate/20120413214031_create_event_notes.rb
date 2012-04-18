class CreateEventNotes < ActiveRecord::Migration
  def change
    create_table :event_notes do |t|
      t.integer :user_id
      t.integer :event_id
      t.text :body
      t.timestamps
    end
  end
end
