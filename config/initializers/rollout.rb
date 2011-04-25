
$redis = Redis.new
$rollout = Rollout.new($redis)

$rollout.define_group(:alpha) do |user|
  user.community.slug == "CommonPlace"
end
