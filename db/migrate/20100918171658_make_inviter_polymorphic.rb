class MakeInviterPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :invites, :user_id, :inviter_id
    change_column :invites, :email, :string, :null => true
    add_column :invites, :inviter_type, :string
    add_column :invites, :invitee_id, :integer
  end

  def self.down
    rename_column :invites, :inviter_id, :user_id
    change_column :invites, :email, :string, :null => false
    remove_column :invites, :inviter_type
    remove_column :invites, :invitee_id
  end
end
