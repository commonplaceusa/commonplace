class Post < ActiveRecord::Base
  
  belongs_to :user

  has_many :replies

  validates_presence_of :user
  validates_presence_of :body, :message => "Please enter some text for your post"

end
