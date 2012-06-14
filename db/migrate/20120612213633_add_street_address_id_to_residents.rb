class AddStreetAddressIdToResidents < ActiveRecord::Migration
  def change
    add_column :residents, :street_address_id, :integer
  end
end
