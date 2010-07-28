class CreateMets < ActiveRecord::Migration
  def self.up
    create_table :mets do |t|
      t.integer :requestee_id, :null => false
      t.integer :requester_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :mets
  end
end
