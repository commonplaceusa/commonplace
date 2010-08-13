class AddSubjectToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :subject, :string
  end

  def self.down
    remove_column :posts, :subject
  end
end
