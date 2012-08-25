CommonPlace.shared.HeaderActivity = CommonPlace.View.extend(
  template: "shared.new_header.header-activity"
  className: "my-activity selected-nav"
  tagName: "li"
  initialize: ->
    @activity = CommonPlace.account.get("activity")

  weekly_cpcredits: ->
    @activity.credits.week

  all_cpcredits: ->
    @activity.credits.all

  sign_up_time: ->
    @activity.created_at

  post_count: ->
    @activity.posts.all

  posts_this_week_count: ->
    @activity.posts.week

  thanks_count: ->
    @activity.thanks.all

  thanks_this_week_count: ->
    @activity.thanks.week

  replies_count: ->
    @activity.replies.all

  replies_this_week_count: ->
    @activity.replies.week

  thanks_received_count: ->
    @activity.received_thanks.all

  thanks_received_this_week_count: ->
    @activity.received_thanks.week

  invites_count: ->
    @activity.invites.all

  invites_this_week_count: ->
    @activity.invites.week

  community_users_count: ->
    @activity.community_users.all

  community_users_this_week_count: ->
    @activity.community_users.week

  community_posts_count: ->
    @activity.community_posts.all

  community_posts_this_week_count: ->
    @activity.community_posts.week

  average_replies_count: ->
    Math.ceil (@activity.community_replies.all / @activity.community_users.all) * 100

  average_replies_this_week_count: ->
    Math.ceil (@activity.community_replies.week / @activity.community_users.all) * 100

  average_posts_count: ->
    Math.ceil (@activity.community_posts.all / @activity.community_users.all) * 100

  average_posts_this_week_count: ->
    Math.ceil (@activity.community_posts.week / @activity.community_users.all) * 100

  invite_url: ->
    "/" + @community_slug() + "/invite"

  percentage_penetration_px: ->
    Math.min 152, (@activity.community_users.all / @activity.households) * 152

  percent_penetration: ->
    Math.min 100, (@activity.community_users.all / @activity.households) * 100

  community_slug: ->
    if CommonPlace.account.isAuth()
      CommonPlace.account.get "community_slug"
    else
      CommonPlace.community.get "slug"
)
