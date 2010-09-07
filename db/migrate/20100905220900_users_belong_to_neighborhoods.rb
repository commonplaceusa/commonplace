class UsersBelongToNeighborhoods < ActiveRecord::Migration
  def self.up
    rename_column :users, :community_id, :neighborhood_id
  end

  def self.down
    rename_column :users, :neighborhood_id, :community_id
  end
end
