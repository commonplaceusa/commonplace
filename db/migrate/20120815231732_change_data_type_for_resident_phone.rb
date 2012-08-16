class ChangeDataTypeForResidentPhone < ActiveRecord::Migration
  def up
    change_table :residents do |t|
      t.change :phone, :string
    end
  end

  def down
  end
end
