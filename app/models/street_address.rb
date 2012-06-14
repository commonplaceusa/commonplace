class StreetAddress < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :logs, Array

  belongs_to :community

  has_many :residents

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
    tags << "address" if self.address?
    tags
  end

end
