var HeaderNav = CommonPlace.View.extend({
  template: "shared.header-nav",
  className: "nav",

  afterRender: function() {
    if (this.hasUnreadMessages()) {
      this.$(".inbox .file").badger("" + this.unreadMessages());
    }
  },

  slug: function() {
    if (CommonPlace.account.isAuth()) {
      return CommonPlace.account.get("community_slug");
    } else {
      return CommonPlace.community.get("slug");
    }
  },
  
  invite_url: function() { return "/" + this.slug() + "/invite"; },
  
  inbox_url: function() { return "/" + this.slug() + "/inbox"; },
  
  avatar_url: function() { return CommonPlace.account.get("avatar_url"); },
  
  account_url: function() { return "/" + this.slug() + "/account"; },
  
  faq_url: function() { return "/" + this.slug() + "/faq"; },
  
  short_name: function() { return CommonPlace.account.get("short_name"); },
  
  neighbor_discount_url: function() {},
  
  privacy_url: function() { return "/" + this.slug() + "/privacy"; },
  
  feeds: function() { return CommonPlace.account.get("feeds"); },
  
  activityIsEnabled: function() { return this.isActive("CPCreditsHeaderView"); },

  unreadMessages: function() { return CommonPlace.account.get("unread"); },

  hasUnreadMessages: function() { return this.unreadMessages() !== 0; }

});
