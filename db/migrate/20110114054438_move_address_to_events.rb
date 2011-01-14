class MoveAddressToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :address, :string
    
    Event.reset_column_information
    
    Event.find_each do |event|
      location = Location.find_by_locatable_type_and_locatable_id('Event', event.id)
      event.address = location.street_address if location
      event.save!
    end

  end

  def self.down
    remove_column :events, :address
  end
end
