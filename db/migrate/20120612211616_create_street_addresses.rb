class CreateStreetAddresses < ActiveRecord::Migration
  def up
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
  def down
    drop_table :street_addresses
  end
end
