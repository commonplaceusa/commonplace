class ChangeDataTypeForResidentNotes < ActiveRecord::Migration
  def up
    change_table :residents do |t|
      t.change :notes, :text
    end
  end

  def down
  end
end
