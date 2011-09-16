class CreateEventCrossPostings < ActiveRecord::Migration
  def self.up
    create_table :event_cross_postings do |t|
      t.integer :event_id
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :event_cross_postings
  end
end
