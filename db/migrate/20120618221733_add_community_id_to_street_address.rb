class AddCommunityIdToStreetAddress < ActiveRecord::Migration
  def change
    add_column :street_addresses, :community_id, :integer
  end
end
