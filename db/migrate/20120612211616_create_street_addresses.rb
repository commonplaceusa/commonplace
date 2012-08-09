class CreateStreetAddresses < ActiveRecord::Migration
  def change
    unless StreetAddress.table_exists?
      create_table :street_addresses do |t|

        t.string :address
        t.string :unreliable_name
        t.text :metadata
        t.text :logs
        t.timestamps
      end
    end
  end
end
