class Reply < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  belongs_to :repliable, :polymorphic => true
  after_create :touch_repliable_replied_at, :update_user_replied_count
  belongs_to :user, :counter_cache => true

  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body

  has_many :thanks, :as => :thankable, :dependent => :destroy

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= replies.created_at AND replies.created_at < ?", start_date.utc, end_date.utc] } }

  scope :today, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]

  scope :this_week, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  def touch_repliable_replied_at
    self.repliable.update_attribute(:replied_at, DateTime.now)
    self.repliable.increment!(:replies_count)

  end

  def update_user_replied_count
    @user=User.find(repliable.user_id)
    @user.update_attribute(:replied_count, @user.replied_count+1)
  end

  def community
    self.repliable.community
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
