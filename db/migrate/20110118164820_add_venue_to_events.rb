class AddVenueToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :venue, :string
  end

  def self.down
    remove_column :events, :venue
  end
end
