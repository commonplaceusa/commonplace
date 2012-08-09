class AddCarrierRouteToStreetAddress < ActiveRecord::Migration
  def change
    add_column :street_addresses, :carrier_route, :string
  end
end
