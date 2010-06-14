class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.string :name, :null => false
      t.string :address, :null => false
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.text :about, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :businesses
  end
end
