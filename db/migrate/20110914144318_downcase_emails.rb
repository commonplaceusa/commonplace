class DowncaseEmails < ActiveRecord::Migration
  def self.up
    User.find_each do |user|
      user.email = user.email.downcase
      user.save :validate => false
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
