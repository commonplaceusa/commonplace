class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :street_address
      t.string :zip_code
      t.decimal :lat
      t.decimal :lng
      t.integer :locatable_id, :null => false
      t.string :locatable_type, :null => false
      t.timestamps
    end

    Location.reset_column_information
    
    [User,Event,Organization].each do |klass|
      klass.all.each do |k|
        Location.create(:locatable_id => k.id,
                        :locatable_type => klass.to_s,
                        :street_address => k.address.split(",").first,
                        :zip_code => k.address.scan(/\d{5}/).first,
                        :lat => k.lat,
                        :lng => k.lng)
      end
    end

    [:users, :events, :organizations].each do |t|
      remove_column t, :address
      remove_column t, :lat
      remove_column t, :lng
    end
                      
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
