class Repliable

  # takes an id of the form "#{repliable.class.name.downcase}_#{repliable.id}" 
  # and returns the relevant record
  def self.find(repliable_id)
    if match_data = repliable_id.match(/^(.+)_(\d+)$/)
      match_data[1].camelize.constantize.find(match_data[2])
    end
  end

end
