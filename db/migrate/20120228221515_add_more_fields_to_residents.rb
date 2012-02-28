class AddMoreFieldsToResidents < ActiveRecord::Migration
  def change
    add_column :residents, :address, :string
  end
end
