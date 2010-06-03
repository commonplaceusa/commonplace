# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100603190328) do

  create_table "users", :force => true do |t|
    t.string   "email",                                               :null => false
    t.string   "crypted_password",                                    :null => false
    t.string   "password_salt",                                       :null => false
    t.string   "persistence_token",                                   :null => false
    t.string   "single_access_token",                                 :null => false
    t.string   "perishable_token",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                                          :null => false
    t.string   "last_name",                                           :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.string   "address",                                             :null => false
    t.decimal  "lat",                 :precision => 15, :scale => 10
    t.decimal  "long",                :precision => 15, :scale => 10
    t.text     "about"
  end

end
