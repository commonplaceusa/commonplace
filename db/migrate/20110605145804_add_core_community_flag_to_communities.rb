class AddCoreCommunityFlagToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :core, :boolean
  end

  def self.down
    remove_column :communities, :core
  end
end
