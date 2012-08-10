class AddAnnouncementsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :announcements_count, :integer, null:false, :default => 0
    sql = <<-SQL
      SELECT users."id", COUNT(*)
      FROM feeds
      INNER JOIN users ON feeds.user_id = users."id"
      INNER JOIN announcements ON announcements.owner_id = feeds.user_id
      GROUP BY users.id
    SQL
    execute(sql).values.each do |pair|
      next unless pair[0].present? and pair[1].present?
      execute("UPDATE users SET announcements_count = #{pair[1]} WHERE id = #{pair[0]}")
    end
  end
  def self.down
    remove_column :users, :announcements_count
  end
end
