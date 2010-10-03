class InvertAnnouncementPrivacy < ActiveRecord::Migration
  def self.up
    change_column :announcements, :public, :boolean, :default => false
    rename_column :announcements, :public, :private
  end

  def self.down
    change_column :announcements, :private, :boolean, :default => true
    rename_column :announcements, :private, :public
  end
end
