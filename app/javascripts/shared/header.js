
var HeaderView = CommonPlace.View.extend({
  template: "shared.header-view",
  id: "header",
  
  afterRender: function() {
    var nav;
    if (CommonPlace.account) {
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
      return "/" + CommonPlace.community.get("slug");
    }
  },
  
  community_name: function() {
    if (CommonPlace.account.isAuth()) {
      return CommonPlace.account.get("community_name");
    } else {
      return CommonPlace.community.get("name");
    }
  }
  
});
