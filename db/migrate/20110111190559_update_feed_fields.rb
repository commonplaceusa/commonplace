class UpdateFeedFields < ActiveRecord::Migration
  def self.up
    add_column :feeds, :avatar_file_name, :string
    add_column :feeds, :address, :string
    add_column :feeds, :hours, :string

    Feed.reset_column_information
    
    Feed.all.each do |feed|
      avatar = Avatar.find_by_owner_type_and_owner_id('Feed', feed.id)
      feed.avatar = avatar.image
      avatar.destroy
      feed.save!
    end
  end

  def self.down
    remove_column :feeds, :avatar_file_name
    remove_column :feeds, :address
    remove_column :feeds, :hours
  end
end
