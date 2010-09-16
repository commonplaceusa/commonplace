class AddSlugToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :slug, :string
  end

  def self.down
    remove_column :communities, :slug
  end
end
