class RemoveNextFlagFromFlag < ActiveRecord::Migration
  def up
    if column_exists? :flags, :next_flag
      remove_column :flags, :next_flag
    end
  end

  def down
  end
end
