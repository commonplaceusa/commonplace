class EventsOwnedByFeedOrUser < ActiveRecord::Migration
  def self.up
    add_column :events, :owner_type, :string
    Event.all.each do |e|
      e.owner_type = "Feed"
    end
    rename_column :events, :feed_id, :owner_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
