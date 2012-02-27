class SentEmail
  include MongoMapper::Document

  key :recipient_email, String, :required => true
  key :subject, String, :required => true
  key :tag_list, String
  key :main_tag, String
  key :status, String
  key :body, String
  key :originating_community_id, Integer

  timestamps!
end
