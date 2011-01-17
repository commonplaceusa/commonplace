class AddImageRemoteUrlToAvatars < ActiveRecord::Migration
  def self.up
    add_column :avatars, :avatar_remote_url, :string
  end

  def self.down
    remove_column :avatars, :avatar_remote_url
  end
end
