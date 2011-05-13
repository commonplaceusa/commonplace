class SetNeighborhoodLatAndLngFromBounds < ActiveRecord::Migration
  def self.up
    Neighborhood.find_each do |neighborhood|
      unless neighborhood.latitude
        lat_lng_sum = neighborhood.bounds.inject do |lat_lng_sum, lat_lng|
          [lat_lng_sum.first + lat_lng.first, lat_lng_sum.last + lat_lng.last]
        end
        
        neighborhood.latitude = lat_lng_sum.first / neighborhood.bounds.count
        neighborhood.longitude = lat_lng_sum.last / neighborhood.bounds.count

        neighborhood.save!
      end
    end
  end

  def self.down
  end
end
