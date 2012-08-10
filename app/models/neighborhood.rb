class Neighborhood < ActiveRecord::Base
  #track_on_creation

  has_many :users
  
  reverse_geocoded_by :latitude, :longitude

  belongs_to :community

  serialize :bounds, Array
  validates_presence_of :name

  # after_create :populate_address

  def populate_address
    if self.community.name === "Test" || self.community.name === "Belmont"
      s = Rails.root.join("app", "text", "BelmontMelissaData.csv")
      CSV.foreach(s, :headers => true) do |row|
        h = row.to_hash
        first = h["FirstName"].capitalize
        last = h["LastName"].capitalize
        name = "#{first} #{last}"
        street = h["Address"].squeeze(" ")

        StreetAddress.create(address: street,
                             carrier_route: h["Crrt"],
                             unreliable_name: name,
                             community: self.community)
      end

      s = Rails.root.join("app", "text", "BelmontUsers.csv")
      CSV.foreach(s, :headers => true) do |row|
        h = row.to_hash
        first = h["First name"].capitalize
        last = h["Last name"].capitalize
        street = h["Address"].squeeze(" ")

        u = User.create!(first_name: first,
                    last_name: last,
                    email: h["Email"],
                    password: "password",
                    address: street,
                    neighborhood: self,
                    community: self.community,
                    referral_source: "Other")
        u.address_correlate
        u.save!
      end

      flyers = []
      "A".upto("I") do |l|
        flyers << "Flyer " + l
      end

      self.community.add_resident_tags(flyers)
    end
  end

  def self.closest_to(location)
    geocoded.near(location, 15).limit(1).first
  end

  def coordinates
    [latitude,longitude]
  end

  def coordinates=(cs)
    self.latitude, self.longitude = *cs
  end

  def contains?(position)
    position.within? self.bounds
  end

  def posts
    Post.where("user_id in (?)", self.user_ids)
  end
end
