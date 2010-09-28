class RemoveAvatarColumnsFromUsersAndOrgs < ActiveRecord::Migration
  def self.up
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :organizations, :avatar_file_name
    remove_column :organizations, :avatar_content_type
    User.reset_column_information!
    Organization.reset_column_information!
    User.all.each {|u| u.avatar = Avatar.new; u.save}
    Organization.all.each {|o| o.avatar = Avatar.new; o.save}
  end

  def self.down
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :organizations, :avatar_file_name, :string
    add_column :organizations, :avatar_content_type, :string
  end
end
