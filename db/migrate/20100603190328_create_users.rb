class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   "email", :null => false 
      t.string   "crypted_password", :null => false 
      t.string   "password_salt", :null => false
      t.string   "persistence_token", :null => false
      t.string   "single_access_token", :null => false
      t.string   "perishable_token", :null => false 
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "first_name", :null => false
      t.string   "last_name" , :null => false
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.string   "address", :null => false
      t.decimal  "lat", :precision => 15, :scale => 10  
      t.decimal  "long", :precision => 15, :scale => 10 
      t.text     "about"      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
