class ChangeDataTypeForResidentPhone < ActiveRecord::Migration
  def up
    change_table :residents do |t|
      t.change :phone, :string
    end
  end

  def down
    change_table :residents do |t|
      t.change :phone, :integer
    end
  end
end
