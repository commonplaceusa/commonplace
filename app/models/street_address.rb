class StreetAddress < ActiveRecord::Base
  include PgSearch
  pg_search_scope :kinda_spelled_like,
    :against => :address,
    :using => :trigram

  serialize :metadata, Hash
  serialize :logs, Array

  belongs_to :community

  has_many :residents
  has_many :flags

  after_create :create_default_resident

  searchable do
    string :address
  end

  def have_dropped_flyers?
    [false, true].sample
  end

  def add_log(date, text, tags)
    self.add_tags(tags)
    self.logs << [date, ": ", text].join
    self.save
  end

  def tags
    tags = []
    tags += self.metadata[:tags] if self.metadata[:tags]
    tags << "address" if self.address?
    tags
  end

  # Creates a default Resident file so that it can be displayed in
  # the Organizer App.
  #
  # Note: It is possible to have two Resident files be the same person with
  # this function if a Resident[:name, :email] file of this person is inputted.
  # This should be resolved with a merge when the person registers as a user.
  def create_default_resident
    split_name = unreliable_name.to_s.split(" ")
    r = Resident.create(
      :community => self.community,
      :first_name => split_name.shift.to_s,
      :last_name => split_name.pop.to_s,
      :address => self.address,
      :street_address => self)

    r.add_tags(self.carrier_route)
  end

end
