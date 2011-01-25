class ChangeTwitterAnnouncementToDigest < ActiveRecord::Migration
  def self.up
    create_table "tweets", :force => true do |t|
      t.string    "screen_name",                    :null => false
      t.text      "body",                           :null => false
      t.string    "url",                            :null => false
      t.integer   "twitter_announcement_id",        :null => false
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end
  end

  def self.down
    drop_table :tweets
  end
end
