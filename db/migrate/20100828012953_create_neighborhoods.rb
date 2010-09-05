class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.decimal :north_bound, :null => false
      t.decimal :south_bound, :null => false
      t.decimal :east_bound, :null => false
      t.decimal :west_bound, :null => false
      t.string :name, :null => false
      t.text :about, :null => false
      t.integer :community_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :neighborhoods
  end
end
