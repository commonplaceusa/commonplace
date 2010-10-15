class AddCategoryToPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :purpose
    add_column :posts, :category, :string
  end

  def self.down
    add_column :posts, :purpose, :string
    remove_column :posts, :category
  end
end
