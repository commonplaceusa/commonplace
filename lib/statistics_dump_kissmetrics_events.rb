class StatisticsDumpKissmetricsEvents
  @queue = :statistics

  def self.perform(redis = Resque.redis)
    require 'simple_xlsx'

    csv = "Identity,Timestamp,Alias\n"

    User.up_to(Date.parse("24/9/2012").to_datetime).each do |user|
      identity = user.email
      timestamp = user.created_at.to_i.to_s
      # event = "Register"
      # prop_community = user.community.slug
      user_alias = user.full_name.gsub('"', '')
      # csv << [identity, timestamp, event, prop_community].join(",") + "\n"
      csv << [identity, timestamp, user_alias].join(",") + "\n"
    end
    puts csv
  end
end
