class Tweet < ActiveRecord::Base
  belongs_to :twitter_announcement
  validates_uniqueness_of :url
  
end
