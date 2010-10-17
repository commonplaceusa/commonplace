class ProfileField < ActiveRecord::Base
  
  belongs_to :organization
  
  before_save :update_position
  
  def update_position
    # Only if position isn't specified...
    self.position = self.organization.profile_fields.length
  end
  
  validates_presence_of :subject
  
end
