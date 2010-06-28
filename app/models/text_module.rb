class TextModule < ActiveRecord::Base

  belongs_to :group

  acts_as_list :scope => :group

  validates_presence_of :body
  validates_presence_of :group
  validates_presence_of :title


end
