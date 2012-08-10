class AddFeedsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :feeds_count, :integer, null:false, :default => 0

    User.reset_column_information
    User.find_each do |user|
      User.update_counters user.id, :feeds_count => user.managable_feeds.length
    end

  end
  def self.down
    remove_column :users, :feeds_count
  end
end
