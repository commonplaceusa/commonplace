class AddImagesToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :logo_file_name, :string
    add_column :communities, :email_header_file_name, :string
  end

  def self.down
    remove_column :communities, :logo_file_name
    remove_column :communities, :email_header_file_name
  end
end
