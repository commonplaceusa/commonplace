class MoveStreetAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :address, :string
    User.reset_column_information

    User.find_each do |user|
      location = Location.find_by_locatable_type_and_locatable_id('User', user.id)
      user.address = location.street_address
      user.save!
    end
  end

  def self.down
    User.find_each do |user|
      location = Location.new(:street_address => user.address, 
                              :zip_code => user.community.zip_code,
                              :locatable_type => 'User', 
                              :locatable_id => user.id)
      location.save!
    end
      
    remove_column :user, :address
  end
end
