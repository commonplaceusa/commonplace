class Feed < ActiveRecord::Base
  
  acts_as_taggable_on :tags

  validates_presence_of :name, :community

  validates_uniqueness_of :slug, :scope => :community_id, :allow_nil => true

  before_create :generate_slug

  belongs_to :community
  belongs_to :user

  has_many :events, :dependent => :destroy, :as => :owner

  has_many :announcements, :dependent => :destroy
  
  has_many :profile_fields, :order => "position"

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user

  has_attached_file(:avatar,                    
                    :styles => { 
                      :thumb => "100x100^", 
                      :normal => "120x120^",
                      :large => "200x200^"
                    },
                    :default_url => "/avatars/missing.png", 
                    :url => "/system/feeds/:id/avatar/:style.:extension",
                    :path => ":rails_root/public/system/feeds/:id/avatar/:style.:extension")

  accepts_nested_attributes_for :profile_fields

  private

  def generate_slug
    string = self.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
    string.strip!
    string.downcase!
    string.gsub!(' ', '-')
    test_string = string
    i = 1
    while Feed.exists?(:slug => test_string, :community_id => self.community.id)
      test_string = "#{string}-#{i}"
      i += 1
    end
    self.slug = test_string
  end
end
