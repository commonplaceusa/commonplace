class Transaction < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content
  serialize :metadata, Hash

  belongs_to :community
  belongs_to :seller, :polymorphic => true, :counter_cache => true, :foreign_key => 'user_id'
  belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'

  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :thanks, :as => :thankable, :dependent => :destroy
  has_many :warnings, :as => :warnable, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy

  validates_presence_of :seller, :community

  acts_as_api

  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "transactions" }, :as => :schema
    t.add :title
  end

  default_scope where(:deleted_at => nil)

  scope :between, lambda { |start_date, end_date|
    { :conditions =>
      ["transactions.created_at between ? and ?", start_date.utc, end_date.utc] }
  }
  scope :up_to, lambda { |end_date| { :conditions => ["transactions.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["transactions.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  def user
    case seller
      when User then seller
      when Feed then seller.user
    end
  end

  # Potential buyers
  def buyers
    metadata[:buyers] ||= []

    User.where("id in (?)", metadata[:buyers])
  end

  # Add user_id of buyer to metadata
  def add_buyer(c_id)
    metadata[:buyers] ||= []

    metadata[:buyers] |= Array(c_id.to_i)
    self.save
  end

  # Seller chose which buyer to sell to
  def buyer_chosen(c_id)
    pending = true

    self.buyer = User.find(c_id)
    self.save
  end

  # To be done later when payments are actually to be implemented

  # Buyer confirmed purchase. Transaction should now be complete
  #
  # What to do at this point?
  # Should this model be destroyed?
  # Should there be a log of transactions somehow?
  def buyer_confirmed
  end

  # Someone wants to buy item. Now on seller to deliver.
  def sell_pending
  end

  # Buyer confirmed item received. Release funds to seller.
  def sell_confirmed
  end

  searchable do
    text :title, :description
    text :author_name do
      seller.name
    end
    text :replies do
      replies.map &:body
    end
    text :reply_author do
      replies.map { |r| r.user.name }
    end
    integer :community_id
    integer :user_id
    integer :reply_author_ids, :multiple => true do
      replies.map { |r| r.user.id }
    end
    time :created_at
  end
end
