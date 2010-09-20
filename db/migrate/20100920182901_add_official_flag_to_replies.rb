class AddOfficialFlagToReplies < ActiveRecord::Migration
  def self.up
    add_column :replies, :official, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :replies, :official
  end
end
