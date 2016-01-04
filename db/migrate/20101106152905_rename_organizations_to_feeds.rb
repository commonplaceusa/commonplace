class RenameOrganizationsToFeeds < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end

  def self.up
    execute "UPDATE avatars SET owner_type = 'Feed' WHERE owner_type = 'Organization'"
    execute "UPDATE taggings SET taggable_type = 'Feed' WHERE taggable_type = 'Organization'"
    add_column :organizations, :user_id, :integer
    execute "UPDATE organizations SET user_id = (SELECT user_id FROM roles WHERE roles.organization_id = organizations.id)"
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
