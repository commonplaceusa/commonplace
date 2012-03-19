class Resident < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :logs, Array

  belongs_to :community

  belongs_to :user

  def on_commonplace?
    self.user_id?
  end

  def friends_on_commonplace?
    [false, true].sample
  end
  
  def in_commonplace_organization?
    [false, true].sample
  end

  def have_dropped_flyers?
    [false, true].sample
  end

  def add_log(date, text, tags)
    self.add_tags(tags)
    self.logs << [date, ": ", text].join
    self.save
  end

  def avatar_url
    begin
      self.user.avatar_url
    rescue
      "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    end
  end

  def tags
    tags = []
    tags += self.metadata[:tags] if self.metadata[:tags]
    tags << "registered" if self.user.present?
    tags << "email" if self.email?
    tags << "address" if self.address?
    tags
  end

  def add_tags(tag_or_tags)
    tags = Array(tag_or_tags)
    self.metadata[:tags] ||= []
    self.metadata[:tags] |= tags
    self.community.add_resident_tags(tags)
    self.save
  end

  searchable do
    integer :community_id
    string :tags, :multiple => true
    string :first_name
    string :last_name
  end

end
