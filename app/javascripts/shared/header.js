
var HeaderView = CommonPlace.View.extend({
  template: "shared.header-view",
  id: "header",
  
  afterRender: function() {
    var nav;
    if (CommonPlace.account.isAuth()) {
      nav = new HeaderNav();
    } else {
      nav = new HeaderLogin();
    }
    nav.render();
    this.$(".nav").replaceWith(nav.el);
  },

  root_url: function() {
    if (CommonPlace.account.isAuth()) {
      return "/" + CommonPlace.account.get("community_slug");
    } else {
      if (CommonPlace.community) return "/" + CommonPlace.community.get("slug");
    }
  },

  hasCommunity: function() { return CommonPlace.community; },
  
  community_name: function() {
    if (CommonPlace.account.isAuth()) {
      return CommonPlace.account.get("community_name");
    } else {
      if (CommonPlace.community) return CommonPlace.community.get("name");
    }
  }
  
});
