class AddEventsCountToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :events_count, :integer, default: 0
  end
end
