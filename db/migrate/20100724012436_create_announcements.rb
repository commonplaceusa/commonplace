class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :subject, :null => false
      t.string :body, :null => false
      t.integer :organization_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
