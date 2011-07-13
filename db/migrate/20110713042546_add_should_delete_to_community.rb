class AddShouldDeleteToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :should_delete, :boolean, :default => false
  end

  def self.down
    remove_column :communities, :should_delete
  end
end
