class ProfileField < ActiveRecord::Base
  
  belongs_to :feed
  
  validates_presence_of :subject, :body

  before_create :append_field

  protected
  
  def append_field
    self.position = self.feed.profile_fields.length
  end
  
end
