class RepliesBelongToRepliable < ActiveRecord::Migration
  def self.up
    rename_column :replies, :post_id, :repliable_id
    add_column :replies, :repliable_type, :string
  end

  def self.down
    rename_column :replies, :repliable_id, :post_id
    remove_column :replies, :repliable_type
  end
end
