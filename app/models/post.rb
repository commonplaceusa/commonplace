class Post < ActiveRecord::Base
  
  belongs_to :user

  validates_presence_of :user
  
  validates_presence_of :body, :message => "Please enter some text for your post"

end
