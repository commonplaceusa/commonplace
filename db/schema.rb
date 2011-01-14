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

ActiveRecord::Schema.define(:version => 20110114092950) do

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "primary"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.string   "subject",                                :null => false
    t.text     "body",                                   :null => false
    t.integer  "feed_id",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",    :default => false,          :null => false
    t.string   "type",       :default => "Announcement"
    t.string   "url"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "name",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "zip_code"
    t.string   "logo_file_name"
    t.string   "email_header_file_name"
    t.text     "signup_message"
  end

  create_table "events", :force => true do |t|
    t.string   "name",            :null => false
    t.text     "description",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "cached_tag_list"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "owner_type"
    t.string   "source_feed_id"
    t.string   "address"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.string   "phone"
    t.string   "website"
    t.integer  "community_id"
    t.string   "category"
    t.string   "cached_tag_list"
    t.string   "code"
    t.boolean  "claimed",          :default => true
    t.integer  "user_id"
    t.string   "type",             :default => "Feed"
    t.string   "feed_url"
    t.string   "avatar_file_name"
    t.string   "address"
    t.string   "hours"
    t.string   "slug"
  end

  create_table "invites", :force => true do |t|
    t.string   "email"
    t.integer  "inviter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
    t.string   "inviter_type"
    t.integer  "invitee_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "street_address"
    t.string   "zip_code"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locatable_id"
    t.string   "locatable_type"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.text     "body",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "recipient_id"
  end

  create_table "mets", :force => true do |t|
    t.integer  "requestee_id", :null => false
    t.integer  "requester_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods", :force => true do |t|
    t.string   "name",         :null => false
    t.integer  "community_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "bounds"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "notifiable_id",   :null => false
    t.string   "notifiable_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notified_id"
    t.string   "notified_type"
  end

  create_table "posts", :force => true do |t|
    t.text     "body",            :null => false
    t.integer  "user_id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.string   "category"
    t.integer  "neighborhood_id"
  end

  create_table "profile_fields", :force => true do |t|
    t.string   "subject",    :null => false
    t.text     "body",       :null => false
    t.integer  "feed_id",    :null => false
    t.integer  "position",   :null => false
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
    t.text     "body",                              :null => false
    t.integer  "repliable_id",                      :null => false
    t.integer  "user_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repliable_type"
    t.boolean  "official",       :default => false, :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "feed_id",    :null => false
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
    t.string  "name"
    t.integer "canonical_tag_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                               :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                   :null => false
    t.string   "single_access_token",                                 :null => false
    t.string   "perishable_token",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                                          :null => false
    t.string   "last_name",                                           :null => false
    t.text     "about"
    t.integer  "neighborhood_id",                                     :null => false
    t.string   "cached_skill_list"
    t.string   "cached_interest_list"
    t.string   "cached_good_list"
    t.boolean  "receive_digests",                  :default => false, :null => false
    t.boolean  "receive_posts",                    :default => true
    t.boolean  "receive_events_and_announcements", :default => true
    t.boolean  "admin",                            :default => false
    t.string   "state"
    t.string   "avatar_file_name"
    t.string   "address"
  end

end
