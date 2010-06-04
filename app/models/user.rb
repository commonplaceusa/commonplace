class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field :email
    c.validate_email_field false
    c.validate_login_field false
  end

  
  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  
  has_attached_file(:avatar,
                     RAILS_ENV == "production" ? {
                      :styles => { :thumb => "100x100" },
                      :storage => :s3,
                      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                      :path => ":attachment/:id/:style.:extension",
                      :default_url => "/images/:attachment/:style/missing.png"
                    } : {
                      :styles => { :thumb => "50x50" },
                      :path => ":attachment/:id/:style.:extension",
                      :default_url => "/images/:attachment/:style/missing.png"
                    })
  


  def full_name
    first_name + " " + last_name
  end


end
