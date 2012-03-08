class Essay < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :feed
  
  validates_presence_of :subject, :body
  
  acts_as_api
  
  api_accessible :default do |t|
    t.add :subject, :as => :title
    t.add :body
    t.add lambda {|e| e.user.name}, :as => :author_name
    t.add :id
    t.add :user_id
    t.add :feed_name do
      self.feed.name
    end
    t.add lambda {|e| e.feed.name}, :as => :feed_name
    t.add :feed_id
  end
end
