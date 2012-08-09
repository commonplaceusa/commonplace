class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|

      t.string :name
      t.integer :resident_id

      t.timestamps
    end
  end
end
