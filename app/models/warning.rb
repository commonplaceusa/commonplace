class Warning < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  belongs_to :user
  belongs_to :warnable, :polymorphic => true

  def community
    self.warnable.community
  end

  def warned_at
    self.updated_at
  end
end
