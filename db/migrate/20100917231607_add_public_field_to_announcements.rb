class AddPublicFieldToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :public, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :announcements, :public
  end
end
