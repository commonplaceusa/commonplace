class CreateFeedOwners < ActiveRecord::Migration
  def change
    create_table :feed_owners do |t|

      t.integer :feed_id
      t.integer :user_id

      t.timestamps
    end

    FeedOwner.reset_column_information

    Feed.find_each do |feed|
      FeedOwner.create!(:user_id => feed.user_id, :feed_id => feed.id)
    end

  end
end
