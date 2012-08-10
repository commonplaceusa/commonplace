class AddCarrierRouteToStreetAddress < ActiveRecord::Migration
  def change
    unless column_exists? :street_addresses, :carrier_route
      add_column :street_addresses, :carrier_route, :string
    end
  end
end
