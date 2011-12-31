class Thankable
  # takes an id of the form "#{thankable.class.name.downcase}_${thankable.id}
  # and returns the relevant record
  def self.find(thankable_id)
    if match_data = thankable_id.match(/^(.+)_(\d+)$/)
      match_data[1].camelize.constantize.find(match_data[2])
    end
  end
end
