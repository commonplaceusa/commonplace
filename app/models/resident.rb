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

  def avatar_url
    begin
      User.find(self.user_id).avatar_url
    rescue
      "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    end
  end

  def tags
    tags = []
    tags += self.metadata[:tags] if self.metadata[:tags]
    tags << "registered" if self.user.present?
    tags
  end

  searchable do
    integer :community_id
    string :tags, :multiple => true
    string :first_name
    string :last_name
  end

end
