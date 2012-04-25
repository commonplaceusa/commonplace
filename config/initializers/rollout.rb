uri = if Rails.env.development?
        URI.parse("localhost:6379")
      elsif ENV["REDISTOGO_URL"].present?
        URI.parse(ENV["REDISTOGO_URL"])
      else
        ""
      end

if uri.present?
  $rollout = Rollout.new(Redis.new(:host => uri.host, 
                                   :port => uri.port, 
                                   :password => uri.password, 
                                   :thread_safe => true))
  $rollout.define_group(:alpha) do |user|
    user.community.slug == "CommonPlace" or user.community.slug == "test"
  end

  $rollout.define_group(:harrisonburg) do |user|
    user.community.slug == "harrisonburg"
  end

  $rollout.define_group(:fallschurch) do |user|
    user.community.slug == "fallschurch" 
  end

  $rollout.define_group(:discount) do |user|
    if user == nil or user.community == nil
      return false
    end
    user.present? and user.community.present? and user.community.slug == "Vienna" or user.community.slug == "test"
  end

  $rollout.activate_group(:facebook_invite, :alpha)
  $rollout.activate_group(:good_neighbor_discount, :discount)

else
  $rollout = Rollout.new(MockRedis.new)
end
