class Warnable
  # takes an id of the form "#{warnable.class.name.downcase}_${warnable.id}
  # and returns the relevant record
  def self.find(warnable_id)
    if match_data = warnable_id.match(/^(.+)_(\d+)$/)
      match_data[1].camelize.constantize.find(match_data[2])
    end
  end
end
