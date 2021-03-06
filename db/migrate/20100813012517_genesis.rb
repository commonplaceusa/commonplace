class Genesis < ActiveRecord::Migration
  def self.up

    create_table "announcements", :force => true do |t|
      t.string   "subject",                        :null => false
      t.text     "body",                           :null => false
      t.integer  "organization_id",                :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "attendances", :force => true do |t|
      t.integer  "event_id",      :null => false
      t.integer  "user_id",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "communities", :force => true do |t|
      t.string   "name",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "conversation_memberships", :force => true do |t|
      t.integer   "user_id",                            :null => false
      t.integer   "conversation_id",                    :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "conversations", :force => true do |t|
      t.string    "subject",    :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "events", :force => true do |t|
      t.string    "name",            :null => false
      t.timestamp "start_time"
      t.timestamp "end_time"
      t.string    "address"
      t.text      "description", :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.decimal   "lat"
      t.decimal   "lng"
      t.integer   "organization_id"
    end

    create_table "invites", :force => true do |t|
      t.string   "email",      :null => false
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "links", :force => true do |t|
      t.integer  "linkable_id",   :null => false
      t.string   "linkable_type", :null => false
      t.integer  "linker_id",     :null => false
      t.string   "linker_type",   :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "messages", :force => true do |t|
      t.integer  "user_id",         :null => false
      t.integer  "conversation_id", :null => false
      t.text     "body",            :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "mets", :force => true do |t|
      t.integer  "requestee_id", :null => false
      t.integer  "requester_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "notifications", :force => true do |t|
      t.integer  "user_id",         :null => false
      t.integer  "notifiable_id",   :null => false
      t.string   "notifiable_type", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "organizations", :force => true do |t|
      t.string   "name",                :null => false
      t.string   "address"
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.decimal  "lat"
      t.decimal  "lng"
      t.text     "about"
      t.string   "phone"
      t.string   "website"
      t.integer  "community_id"
    end

    create_table "platform_updates", :force => true do |t|
      t.string   "subject",    :null => false
      t.text     "body",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "posts", :force => true do |t|
      t.text     "body",                           :null => false
      t.integer  "user_id",                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "purpose",    :default => "tell", :null => false
    end

    create_table "profile_fields", :force => true do |t|
      t.string   "subject",                        :null => false
      t.text     "body",                           :null => false
      t.integer  "organization_id",                :null => false
      t.integer  "position",                       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "referrals", :force => true do |t|
      t.integer  "event_id",    :null => false
      t.integer  "referee_id",  :null => false
      t.integer  "referrer_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "replies", :force => true do |t|
      t.text      "body",       :null => false
      t.integer   "post_id",    :null => false
      t.integer   "user_id",    :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "roles", :force => true do |t|
      t.integer  "user_id",         :null => false
      t.integer  "organization_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "subscriptions", :force => true do |t|
      t.integer  "user_id",         :null => false
      t.integer  "organization_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "taggings", :force => true do |t|
      t.integer   "tag_id"
      t.integer   "taggable_id"
      t.integer   "tagger_id"
      t.string    "tagger_type"
      t.string    "taggable_type"
      t.string    "context"
      t.timestamp "created_at"
    end

    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

    create_table "tags", :force => true do |t|
      t.string "name"
    end

    create_table "users", :force => true do |t|
      t.string    "email",               :null => false
      t.string    "crypted_password",    :null => false
      t.string    "password_salt",       :null => false
      t.string    "persistence_token",   :null => false
      t.string    "single_access_token", :null => false
      t.string    "perishable_token",    :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.string    "first_name",          :null => false
      t.string    "last_name",           :null => false
      t.string    "avatar_file_name"
      t.string    "avatar_content_type"
      t.string    "address",             :null => false
      t.decimal   "lat"
      t.decimal   "lng"
      t.text      "about"
      t.integer   "community_id",        :null => false
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
