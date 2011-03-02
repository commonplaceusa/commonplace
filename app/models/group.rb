class Group < ActiveRecord::Base
  
  validates_presence_of :name, :slug, :about, :community

  belongs_to :community
  
end
