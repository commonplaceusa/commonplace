class AddMiddleNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :middle_name, :string
    User.find(:all).each do |user|
      if user.last_name.include? " "
        user.full_name = user.first_name.to_s + " " + user.last_name.to_s
	user.save
      end
    end
  end

  def self.down
    remove_column :users, :middle_name
  end
end
