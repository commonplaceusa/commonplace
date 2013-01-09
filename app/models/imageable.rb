class Imageable
  # takes an id of the form "#{imageable.class.name.downcase}_${imageable.id}
  # and returns the relevant record
  def self.find(imageable_id)
    if match_data = imageable_id.match(/^(.+)_(\d+)$/)
      match_data[1].camelize.constantize.find(match_data[2])
    end
  end
end
