class AddInviteCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invites_count, :integer, null:false, :default => 0
    invitation_counts = execute("SELECT invites.inviter_id, COUNT(*) FROM invites GROUP BY inviter_id").values
    if invitation_counts.present?
      invitation_counts.each do |pair|
        next unless pair[0].present? and pair[1].present?
        execute("UPDATE users SET invites_count = #{pair[1]} where id = #{pair[0]}")
      end
    end
  end
  def self.down
    remove_column :users, :invites_count
  end
end
