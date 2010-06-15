class CreateTextModules < ActiveRecord::Migration
  def self.up
    create_table :text_modules do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.integer :organization_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :text_modules
  end
end
