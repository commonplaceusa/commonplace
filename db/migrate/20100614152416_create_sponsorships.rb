class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.integer :sponsor_id, :null => false
      t.string :sponsor_type, :null => false
      t.integer :event_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
