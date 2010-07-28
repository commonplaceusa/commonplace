class Met < ActiveRecord::Base
  belongs_to :requestee, :class_name => "User"
  belongs_to :requester, :class_name => "User"

end
