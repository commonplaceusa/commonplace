class Migrate2011To2012 < ActiveRecord::Migration
  def up
    Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)

    say_with_time "adding replies_count and posts_count to users" do
      add_column :users, :replies_count, :integer
      add_column :users, :posts_count, :integer
    end

    say_with_time "making users trackable" do
      change_table(:users) do |t|
        t.integer  :sign_in_count, :default => 0
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip
      end
    end

    say_with_time "adding private_metadata to users" do
      add_column :users, :private_metadata, :text
    end

    say_with_time "adding calculated_cp_credits to users" do
      add_column :users, :calculated_cp_credits, :integer
      add_column :users, :cp_credits_are_valid, :boolean, :default => false
    end

    say_with_time "adding metadata to users" do
      add_column :users, :metadata, :text
    end
    
    say_with_time "add replied_at to repliables" do
      [:posts, :events, :announcements, :group_posts, :messages].each do |t|
        add_column t, :replied_at, :datetime
      end
    end

    say_with_time "add thanks" do
      create_table :thanks do |t|
        t.integer :user_id
        t.integer :thankable_id
        t.string :thankable_type
        
        t.timestamps
      end
    end

    say_with_time "UserAnnouncements become Posts" do
      Post.find_each do |post|
        post.update_attribute :category, "neighborhood"
      end
      
      Announcement.where(owner_type: "User").each do |announcement|
        Post.create!(
          :community_id => announcement.community_id,
          :subject => announcement.subject,
          :body => announcement.body,
          :category => "publicity",
          :created_at => announcement.created_at,
          :updated_at => announcement.updated_at,
          :user => announcement.owner,
          :replies => announcement.replies
          )
        announcement.destroy
      end
    end

    say_with_time "remove all replies without repliables" do
      Reply.find_each do |reply|
        reply.destroy unless reply.repliable
      end
    end

  end

  def down

    say_with_time "removing replies_count and posts_count from users" do
      remove_column :users, :replies_count
      remove_column :users, :posts_count
    end

    say_with_time "making users untrackable" do 
      remove_column :users,  :sign_in_count
      remove_column :users, :current_sign_in_at
      remove_column :users, :last_sign_in_at
      remove_column :users, :current_sign_in_ip
      remove_column :users, :last_sign_in_ip
    end

    say_with_time "removing private metadata" do
      remove_column :users, :private_metadata
    end

    say_with_time "removing calculated_cp_credits from users" do
      remove_column :users, :calculated_cp_credits
      remove_column :users, :cp_credits_are_valid
    end

    say_with_time "removing metadata from users" do
      remove_column :users, :metadata
    end

    say_with_time "removing replied_at from repliables" do
      [:posts, :events, :announcements, :group_posts, :messages].each do |t|
        remove_column t, :replied_at
      end
    end

    say_with_time "removing thanks" do
      drop_table :thanks
    end

    say_with_time "Publicity Posts become Announcements" do
      Post.where(category: "publicity").each do |post|
        Announcement.create!(
          :community_id => post.community_id,
          :subject => post.subject,
          :body => post.body,
          :owner_type => "User",
          :created_at => post.created_at,
          :updated_at => post.updated_at,
          :owner => post.user,
          :replies => post.replies
          )
        post.destroy
      end
    end
    

  end
end
