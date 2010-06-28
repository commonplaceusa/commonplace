class AddWebsiteColumnToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :website, :string
  end

  def self.down
    remove_column :groups, :website
  end
end
