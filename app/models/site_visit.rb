class SiteVisit
  include MongoMapper::Document

  # key <name>, <type>
  key :ip_address, String, :required => true
  key :path, String, :required => true

  key :commonplace_account_id, Integer
  key :original_visit_id, Integer

  key :time_left, Date

  timestamps!
end
