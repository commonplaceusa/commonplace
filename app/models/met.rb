class Met < ActiveRecord::Base
  belongs_to :requestee, :class_name => "User"
  belongs_to :requester, :class_name => "User"

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= mets.created_at AND mets.created_at < ?", start_date.utc, end_date.utc] } }

  def wanted_id
    requestee_id
  end

end
