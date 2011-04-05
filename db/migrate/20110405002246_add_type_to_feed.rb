class AddTypeToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :kind, :integer
  end

  def self.down
    remove_column :feeds, :kind
  end
end
