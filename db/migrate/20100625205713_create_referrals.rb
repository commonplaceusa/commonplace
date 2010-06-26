class CreateReferrals < ActiveRecord::Migration
  def self.up
    create_table :referrals do |t|
      t.integer :event_id, :null => false
      t.integer :referee_id, :null => false
      t.integer :referrer_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :referrals
  end
end
