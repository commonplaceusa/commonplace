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

ActiveRecord::Schema.define(:version => 20100622172420) do

  create_table "attendances", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversation_memberships", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "conversation_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new_messages",    :default => false
  end

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",        :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "address"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat"
    t.decimal  "lng"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",                                            :null => false
    t.string   "address"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                :default => "Organization", :null => false
    t.decimal  "lat"
    t.decimal  "lng"
    t.text     "about"
    t.string   "phone"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "conversation_id", :null => false
    t.text     "body",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "post_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsorships", :force => true do |t|
    t.integer  "sponsor_id",   :null => false
    t.string   "sponsor_type", :null => false
    t.integer  "event_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "text_modules", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "organization_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :null => false
    t.string   "crypted_password",    :null => false
    t.string   "password_salt",       :null => false
    t.string   "persistence_token",   :null => false
    t.string   "single_access_token", :null => false
    t.string   "perishable_token",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",          :null => false
    t.string   "last_name",           :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.string   "address",             :null => false
    t.decimal  "lat"
    t.decimal  "lng"
    t.text     "about"
  end

end
