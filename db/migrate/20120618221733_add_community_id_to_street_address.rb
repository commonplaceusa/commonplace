class AddCommunityIdToStreetAddress < ActiveRecord::Migration
  def change
    unless column_exists? :street_addresses, :community_id
      add_column :street_addresses, :community_id, :integer
    end
  end
end
