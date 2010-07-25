class AddCommunityColumnToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :community_id, :integer
  end

  def self.down
    drop_column :organizations, :community_id
  end
end
