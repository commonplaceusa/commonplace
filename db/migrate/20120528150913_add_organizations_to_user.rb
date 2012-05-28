class AddOrganizationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :organizations, :string
  end
end
