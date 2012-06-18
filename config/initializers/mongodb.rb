MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOLAB_URI'] || 'mongodb://localhost/commonplace_stats'
  }
}

if Rails.env.production? || ENV['MONGOLAB_URI']
  MongoMapper.connect(Rails.env)

  #HACK
  if SentEmail.count < 10
    # This is a test database...
    SentEmail.all.map &:destroy

    # Dummy data
    2.times do |i|
      SentEmail.create(originating_community_id: Community.where("core = true").first.id,
                      recipient_email: "jberlinsky@gmail.com",
                      tag_list: "daily_bulletin",
                      status: "sent",
                      main_tag: "daily_bulletin")
    end
    email = SentEmail.last
    email.status = "opened"
    email.save
  end

  if SiteVisit.count < 10
    5.times do |i|
      SiteVisit.create(
          :ip_address => '0.0.0.0',
          :path => '/',
          :commonplace_account_id => '123',
          :community_id => Community.where("core = true").first.id)
    end
  end
else
  MongoMapper.connection = EmbeddedMongo::Connection.new
  MongoMapper.database = 'commonplace_embeddable'
end
