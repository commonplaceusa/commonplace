class SentEmail
  include MongoMapper::Document

  key :recipient_email, String, :required => true
  key :main_tag, String
  key :status, String
  key :originating_community_id, Integer
  key :email_type, String

  timestamps!
end
