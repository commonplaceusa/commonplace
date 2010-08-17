class Item < ActiveRecord::Base

  def self.find(type,params)
    type.capitalize.constantize.find(params)
  end
  

end
