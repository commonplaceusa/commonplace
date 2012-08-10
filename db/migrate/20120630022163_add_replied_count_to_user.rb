class AddRepliedCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :replied_count, :integer, null:false, :default => 0
    grouped_sql = "SELECT users.id,COUNT(replies.id) FROM users JOIN posts ON posts.user_id = users.id JOIN replies ON posts.id = replies.repliable_id GROUP BY users.id"
    result = execute(grouped_sql).values
    result.each do |pair|
      next unless pair[0].present? and pair[1].present?
      execute("UPDATE users SET replied_count = #{pair[1]} WHERE id = #{pair[0]}")
    end if result.present?
  end
  def self.down
    remove_column :users, :replied_count
  end
end
