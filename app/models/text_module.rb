class TextModule < ActiveRecord::Base

  belongs_to :organization

  acts_as_list :scope => :organization

  validates_presence_of :body
  validates_presence_of :organization
  validates_presence_of :title


end
