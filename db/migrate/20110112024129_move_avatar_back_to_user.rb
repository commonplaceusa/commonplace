class MoveAvatarBackToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_file_name, :string
    
    Feed.reset_column_information

    User.all.each do |user|
      if avatar = Avatar.find_by_owner_type_and_owner_id('User', user.id)
        user.avatar = avatar.image
        user.save!
        avatar.destroy
      end
    end
  end

  def self.down
    remove_column :users, :avatar_file_name
  end
end
