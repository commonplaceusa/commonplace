class SentEmail
  include MongoMapper::Document

  key :recipient_email, String, :required => true
  key :subject, String, :required => true
  key :tag_list, String
  key :status, String
  key :body, String

  key :opened_at, Date

  timestamps!
end
