
$redis = Redis.new
$rollout = Rollout.new($redis)

$rollout.define_group(:alpha) do |user|
  user.community.slug == "CommonPlace"
end

$rollout.define_group(:harrisonburg) do |user|
  user.community.slug == "harrisonburg"
end

$rollout.define_group(:fallschurch) do |user|
  user.community.slug == "fallschurch" 
end
