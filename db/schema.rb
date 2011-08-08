# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110808165533) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "announcements", :force => true do |t|
    t.string   "subject",                                  :null => false
    t.text     "body",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",      :default => false,          :null => false
    t.string   "type",         :default => "Announcement"
    t.string   "url"
    t.integer  "community_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "tweet_id"
  end

  create_table "archived_posts", :id => false, :force => true do |t|
    t.integer  "id",                :null => false
    t.text     "body",              :null => false
    t.integer  "user_id",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.string   "category"
    t.integer  "community_id"
    t.boolean  "sent_to_community"
    t.boolean  "published"
    t.datetime "deleted_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "name",                                                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "zip_code"
    t.string   "logo_file_name"
    t.string   "email_header_file_name"
    t.text     "signup_message"
    t.string   "organizer_email"
    t.string   "organizer_name"
    t.string   "organizer_avatar_file_name"
    t.text     "organizer_about"
    t.string   "time_zone",                  :default => "Eastern Time (US & Canada)"
    t.integer  "households",                 :default => 0
    t.boolean  "core"
    t.boolean  "should_delete",              :default => false
    t.boolean  "is_college",                 :default => false
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
    t.string   "venue"
    t.string   "type"
    t.string   "host_group_name"
    t.integer  "community_id"
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
    t.string   "twitter_name"
    t.integer  "kind"
  end

  create_table "group_posts", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "about"
    t.integer  "community_id"
    t.string   "avatar_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "half_users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "street_address"
    t.string   "email"
    t.string   "single_access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "middle_name"
    t.integer  "community_id"
  end

  create_table "internships", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "college"
    t.integer  "graduation_year"
    t.text     "essay"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receive_method", :default => "Live"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.text     "body",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "messagable_id"
    t.string   "messagable_type"
    t.boolean  "archived"
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
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  create_table "organizer_data_points", :force => true do |t|
    t.integer  "organizer_id"
    t.string   "address"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "body",                                :null => false
    t.integer  "user_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.string   "category"
    t.integer  "community_id"
    t.boolean  "sent_to_community"
    t.boolean  "published",         :default => true
    t.datetime "deleted_at"
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

  create_table "requests", :force => true do |t|
    t.string   "community_name"
    t.string   "name"
    t.string   "email"
    t.string   "sponsor_organization"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "feed_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receive_method", :default => "Daily"
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

  create_table "tweets", :force => true do |t|
    t.string   "screen_name",             :null => false
    t.text     "body",                    :null => false
    t.string   "url",                     :null => false
    t.integer  "twitter_announcement_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                             :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token",                                               :null => false
    t.string   "perishable_token",                                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                                                        :null => false
    t.string   "last_name",                                                         :null => false
    t.text     "about"
    t.integer  "neighborhood_id",                                                   :null => false
    t.string   "interest_list"
    t.string   "offer_list"
    t.boolean  "receive_events_and_announcements",              :default => true
    t.boolean  "admin",                                         :default => false
    t.string   "state"
    t.string   "avatar_file_name"
    t.string   "address"
    t.integer  "facebook_uid",                     :limit => 8
    t.string   "oauth2_token"
    t.integer  "community_id"
    t.boolean  "receive_weekly_digest",                         :default => true
    t.string   "post_receive_method",                           :default => "Live"
    t.string   "middle_name"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "referral_source"
    t.datetime "last_login_at"
    t.boolean  "seen_tour"
    t.boolean  "transitional_user"
    t.string   "skills_list"
  end

  add_index "users", ["oauth2_token"], :name => "index_users_on_oauth2_token"

end
