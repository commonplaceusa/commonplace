class AddMiddleNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :middle_name, :string
    User.find(:all).each do |user|
      if user.last_name.include? " "
	middle = user.last_name.split " "
	user.middle_name = middle[1..middle.length-2].join " "
	user.save
      end
    end
  end

  def self.down
    remove_column :users, :middle_name
  end
end
