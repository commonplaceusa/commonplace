class AddPhoneAndOrganization < ActiveRecord::Migration
  def up
    begin
      add_column :residents, :phone, :integer
      add_column :residents, :organization, :string
    rescue
    end
  end
  def down
    remove_column :residents, :phone
    remove_column :residents, :organization
  end
end
