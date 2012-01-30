class Reply < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :repliable, :polymorphic => true
  after_create :touch_repliable_replied_at
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }

  scope :today, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]

  scope :this_week, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  def touch_repliable_replied_at
    self.repliable.update_attribute(:replied_at, DateTime.now)
    
  end

  acts_as_api 
  
  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "replies" }, :as => :schema
    t.add ->(m) { m.repliable.subject }, :as => :title
    t.add ->(m) { m.repliable.class.name.downcase.pluralize }, :as => :repliable_schema
    t.add :repliable_id
  end
end
