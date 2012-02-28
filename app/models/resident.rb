class Resident < ActiveRecord::Base
  serialize :metadata, Hash

  belongs_to :community

  belongs_to :user

  def on_commonplace?
    self.user.present?
  end

  def friends_on_commonplace?
    [false, true].sample
  end
  
  def in_commonplace_organization?
    [false, true].sample
  end

  def have_dropped_flyers?
    [false, true].sample
  end

  def add_log(log)
    
  end

  def logs
    ["Bought a cow.", "Borrowed a babysitter.", "Hoed the lawn."]
  end

end
