class AddBodyFieldToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :body, :text
  end

  def self.down
    remove_column :invites, :body
  end
end
