class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :name
      t.string :primary
      t.decimal :lat
      t.decimal :lng
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
