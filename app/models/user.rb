class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field :email
  end

  has_many :attendances
  has_many :events, :through => :attendances

  has_many :posts

  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :stuffs
  
  has_attached_file(:avatar, {
                      :styles => { :thumb => "100x100" },
                      #:path => ":attachment/:id/:style.:extension",
                      :default_url => "/system/avatars/missing.png"
                    })

  def full_name
    first_name + " " + last_name
  end

end
