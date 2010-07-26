class DropTextModuleTable < ActiveRecord::Migration
  def self.up
    drop_table :text_modules
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
