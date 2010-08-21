class AddCategoryColumnToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :category, :string
  end

  def self.down
    remove_column :organizations, :category
  end
end
