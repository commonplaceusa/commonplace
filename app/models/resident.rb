class Resident < ActiveRecord::Base
  serialize :metadata, Hash
end
