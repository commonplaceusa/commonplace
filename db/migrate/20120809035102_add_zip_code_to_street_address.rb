class AddZipCodeToStreetAddress < ActiveRecord::Migration
  def change
    add_column :street_addresses, :zip_code, :integer
  end
end
