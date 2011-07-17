class AddCommunityIdToHalfUsers < ActiveRecord::Migration
  def self.up
    add_column :half_users, :community_id, :integer
  end

  def self.down
    remove_column :half_users, :community_id
  end
end
