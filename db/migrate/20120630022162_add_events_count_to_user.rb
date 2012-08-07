class AddEventsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :events_count, :integer, null:false, :default => 0
    grouped_sql = "SELECT events.owner_id, COUNT(*) FROM events WHERE owner_type = 'User' GROUP BY owner_id"
    result = execute(grouped_sql).values
    result.each do |pair|
      next unless pair[0].present? and pair[1].present?
      execute("UPDATE users SET events_count = #{pair[1]} WHERE id = #{pair[0]}")
    end if result.present?
  end
  def self.down
    remove_column :users, :events_count
  end
end
