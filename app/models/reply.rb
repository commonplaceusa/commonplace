class Reply < ActiveRecord::Base

  belongs_to :post
  belongs_to :user
  
  validates_presence_of :post
  validates_presence_of :user
  validates_presence_of :body


end
