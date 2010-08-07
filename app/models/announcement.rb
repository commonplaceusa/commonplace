class Announcement < ActiveRecord::Base
  belongs_to :organization
  validates_presence_of :subject, :body
  
  def author_name
    return self.organization.name
  end
  
  def time
    self.created_at
  end
end
