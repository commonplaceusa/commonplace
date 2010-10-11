class ProfileField < ActiveRecord::Base
  
  belongs_to :organization
  
  validates_presence_of :subject, :body

  before_create :append_field

  protected
  
  def append_field
    self.position = self.organization.profile_fields.length
  end
  
end
