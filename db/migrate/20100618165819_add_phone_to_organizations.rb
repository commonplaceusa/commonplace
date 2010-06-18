class AddPhoneToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :phone, :string
  end

  def self.down
    remove_column :organizations, :phone
  end
end
