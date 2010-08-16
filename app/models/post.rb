class Post < ActiveRecord::Base
  
  require "lib/helper"
  
  belongs_to :user

  has_many :replies, :as => :repliable
  has_many :users, :through => :replies, :uniq => true
  validates_presence_of :user
  validates_presence_of :body, :message => "Please enter some text for your post"

  def self.human_name
    "Neighborhood Post"
  end
  
  def time
    help.post_date self.created_at
  end
  
  def owner
    self.user
  end
  
end
