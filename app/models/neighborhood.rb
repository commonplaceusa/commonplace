class Neighborhood < ActiveRecord::Base
  has_many :users

  has_many(:posts, 
           :finder_sql => %q[
SELECT posts.* FROM posts
WHERE (posts.area_type = 'Neighborhood' AND
       posts.area_id = #{id}) OR
      (posts.area_type = 'Community' AND
       posts.area_id = #{community_id})
])

 

  belongs_to :community

  has_many :notifications, :as => :notified

  serialize :bounds, Array

  validates_presence_of :name, :bounds

  def contains?(position)
    position.within? self.bounds
  end

end
