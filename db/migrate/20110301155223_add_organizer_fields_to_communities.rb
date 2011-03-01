class AddOrganizerFieldsToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :organizer_email, :string
    add_column :communities, :organizer_name, :string
    add_column :communities, :organizer_avatar_file_name, :string
    add_column :communities, :organizer_about, :text
  end

  def self.down
    remove_column :communities, :organizer_email
    remove_column :communities, :organizer_name
    remove_column :communities, :organizer_avatar_file_name
    remove_column :communities, :organizer_about
  end

end
