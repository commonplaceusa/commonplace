class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field :email
    c.validate_email_field false
    c.validate_login_field false
  end  

end
