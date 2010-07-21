class CreateAttendancesAndUpdateEvents < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :event_id, :null => false
      t.integer :user_id, :null => false
      t.integer :attending, :null => false
      t.timestamps
    end
  end

  def self.down  
    raise ActiveRecord::IrreversibleMigration
  end
end