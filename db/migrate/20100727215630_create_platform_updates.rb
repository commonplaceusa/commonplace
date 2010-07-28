class CreatePlatformUpdates < ActiveRecord::Migration
  def self.up
    create_table :platform_updates do |t|
      t.string :subject, :null => false
      t.text :body, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :platform_updates
  end
end
