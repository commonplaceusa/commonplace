class AddCommunityIdToStreetAddress < ActiveRecord::Migration
  def change
    begin
      add_column :street_addresses, :community_id, :integer
    rescue
    end
  end
end
