class CreateFlags < ActiveRecord::Migration
  def up
    unless Flag.table_exists?
      create_table :flags do |t|

        t.string :name
        t.integer :resident_id

        t.timestamps
      end
    end
  end
  def down
    drop_table :flags
  end
end
