class CreateAnnouncementCrossPostings < ActiveRecord::Migration
  def self.up
    create_table :announcement_cross_postings do |t|
      t.integer :announcement_id
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :announcement_cross_postings
  end
end
