class AddSignupTextToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :signup_message, :text
  end

  def self.down
    remove_column :communities, :signup_message
  end
end
