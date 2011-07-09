module IDEncoder
  require 'base64'
  
  def self.from_long_id(long_id)
    # Reconstruct the equal signs at the end
    num = long_id[long_id.length-1,long_id.length-1]
    long_id = long_id[0,long_id.length-1]
    num.to_i.times do |i|
      long_id += "="
    end
    # Find the post
    Base64.decode64(long_id)
  end
  
  def self.to_long_id(id)
    # Return the base-64 encoded post ID, replacing any tailing = characters with their quantity
    require 'base64'
    long_id = Base64.encode64(id.to_s)
     m = long_id.match(/[A-Za-z0-9]*(=*)/)
    
    if m[1].present?
      long_id = long_id.gsub(m[1],m[1].length.to_s)
    else
      long_id = long_id + "0"
    end
    long_id.gsub("\n","")
  end
end