class AddArchivableToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :archived, :boolean, :default => :false
  end

  def self.down
    remove_column :messages, :archived
  end
end
