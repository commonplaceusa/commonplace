class AddZipCodeToStreetAddress < ActiveRecord::Migration
  def change
    unless column_exists? :street_addresses, :zip_code
      add_column :street_addresses, :zip_code, :integer
    end
  end
end
