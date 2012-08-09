class CreateFlags < ActiveRecord::Migration
  def change
    begin
      create_table :flags do |t|

        t.string :name
        t.integer :resident_id

        t.timestamps
      end
    rescue
    end
  end
end
