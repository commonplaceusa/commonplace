var HeaderActivity = CommonPlace.View.extend({
  template: "shared.header-activity",
  className: "my-activity selected-nav",
  tagName: "li",
  
  initialize: function() { this.activity = CommonPlace.account.get("activity"); },
  
  weekly_cpcredits: function() { return this.activity.credits.week; },
  all_cpcredits: function() { return this.activity.credits.all; },
  sign_up_time: function() { return this.activity.created_at; },
  
  post_count: function() { return this.activity.posts.all; },
  posts_this_week_count: function() { return this.activity.posts.week; },
  thanks_count: function() { return this.activity.thanks.all; },
  thanks_this_week_count: function() { return this.activity.thanks.week; },
  replies_count: function() { return this.activity.replies.all; },
  replies_this_week_count: function() { return this.activity.replies.week; },
  thanks_received_count: function() { return this.activity.received_thanks.all; },
  thanks_received_this_week_count: function() { return this.activity.received_thanks.week; },
  invites_count: function() { return this.activity.invites.all; },
  invites_this_week_count: function() { return this.activity.invites.week; },
  
  community_users_count: function() { return this.activity.community_users.all; },
  community_users_this_week_count: function() { return this.activity.community_users.week; },
  community_posts_count: function() { return this.activity.community_posts.all; },
  community_posts_this_week_count: function() { return this.activity.community_posts.week; },
  average_replies_count: function() {
    return Math.ceil((this.activity.community_replies.all / this.activity.community_users.all) * 100);
  },
  average_replies_this_week_count: function() {
    return Math.ceil((this.activity.community_replies.week / this.activity.community_users.all) * 100);
  },
  average_posts_count: function() {
    return Math.ceil((this.activity.community_posts.all / this.activity.community_users.all) * 100);
  },
  average_posts_this_week_count: function() {
    return Math.ceil((this.activity.community_posts.week / this.activity.community_users.all) * 100);
  },
  
  
  invite_url: function() { return "/" + this.community_slug() + "/invite"; },
  percentage_penetration_px: function() {
    return Math.min(152, (this.activity.community_users.all / this.activity.households) * 152);
  },
  percent_penetration: function() {
    return Math.min(100, (this.activity.community_users.all / this.activity.households) * 100);
  },
  
  community_slug: function() {
    if (CommonPlace.account.isAuth()) {
      return CommonPlace.account.get("community_slug");
    } else {
      return CommonPlace.community.get("slug");
    }
  }

});
