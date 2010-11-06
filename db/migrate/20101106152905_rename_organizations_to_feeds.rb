class RenameOrganizationsToFeeds < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end

  def self.up
    Avatar.all.select {|a| a.owner_type == "Organization"}.each do |a|
      a.owner_type = "Feed"
      a.save
    end
    
    ActsAsTaggableOn::Tagging.all.select {|t| t.taggable_type == "Organization"}.each do |t|
      t.taggable_type = "Feed"
      t.save
    end

    add_column :organizations, :user_id, :integer

    Role.all.each do |r|
      begin
        o = Organization.find(r.organization_id)
        o.user_id = r.user_id 
        o.save
      rescue
      end
    end

    rename_column :announcements,  :organization_id, :feed_id
    rename_column :events,         :organization_id, :feed_id
    rename_column :profile_fields, :organization_id, :feed_id
    rename_column :subscriptions,  :organization_id, :feed_id

    rename_table :organizations, :feeds
    
    drop_table :roles
        
    drop_table :links

    drop_table :platform_updates
    
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
