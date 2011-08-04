uri = URI.parse(ENV["REDISTOGO_URL"] || "localhost:6379")

$rollout = Rollout.new(Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true))

$rollout.define_group(:alpha) do |user|
  user.community.slug == "CommonPlace" or user.community.slug == "test"
end

$rollout.define_group(:harrisonburg) do |user|
  user.community.slug == "harrisonburg"
end

$rollout.define_group(:fallschurch) do |user|
  user.community.slug == "fallschurch" 
end

$rollout.define_group(:umw) do |user|
  user.community.slug == "Vienna"
end

# TODO: UMW should be a subgroup of College
$rollout.activate_group(:custom_locale, :umw)

$rollout.activate_group(:facebook_invite, :alpha)
