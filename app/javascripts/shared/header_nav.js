var HeaderNav = CommonPlace.View.extend({
  template: "shared.header-nav",
  className: "nav",

  afterRender: function() {
    var activity = new HeaderActivity();
    activity.render();
    this.$("li.my-activity").replaceWith(activity.el);
  },
  
  slug: function() { return CommonPlace.community.get("slug"); },
  
  invite_url: function() { return "/" + this.slug() + "/invite"; },
  
  inbox_url: function() { return "/" + this.slug() + "/inbox"; },
  
  avatar_url: function() { return CommonPlace.account.get("avatar_url"); },
  
  account_url: function() { return "/" + this.slug() + "/account"; },
  
  faq_url: function() { return "/" + this.slug() + "/faq"; },
  
  short_name: function() { return CommonPlace.account.get("short_name"); },
  
  neighbor_discount_url: function() {},
  
  privacy_url: function() { return "/" + this.slug() + "/privacy"; },
  
  feeds: function() { return CommonPlace.account.get("feeds"); },
  
  activityIsEnabled: function() { return this.isActive("CPCreditsHeaderView"); }

});
