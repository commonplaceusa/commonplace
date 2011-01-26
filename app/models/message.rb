class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, :class_name => "User"
  validates_presence_of :subject, :body
  
  def long_id
    # Return the base-64 encoded post ID, replacing any tailing = characters with their quantity
    require 'base64'
    long_id = Base64.b64encode(self.id.to_s)
     m = long_id.match(/[A-Za-z0-9]*(=*)/)
    
    if m[1].present?
      long_id = long_id.gsub(m[1],m[1].length.to_s)
    else
      long_id = long_id + "0"
    end
    long_id.gsub("\n","")
  end
  
  def self.find_by_long_id(long_id)
    # Decode the base-64 encoding done in Post.long_id, and get the post
    require 'base64'
    # Reconstruct the equal signs at the end
    num = long_id[long_id.length-1,long_id.length-1]
    long_id = long_id[0,long_id.length-1]
    num.to_i.times do |i|
      long_id += "="
    end
    # Find the post
    message_id = Base64.decode64(long_id)
    Message.find(message_id)
  end
  
end
