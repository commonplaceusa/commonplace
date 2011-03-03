class AddSendToCommunityFlagToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :sent_to_community, :boolean
  end

  def self.down
    remove_column :posts, :sent_to_community
  end
end
