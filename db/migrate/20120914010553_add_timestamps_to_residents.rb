class AddTimestampsToResidents < ActiveRecord::Migration
  def change
    change_table :residents do |t|
      t.timestamps
    end
  end
end
