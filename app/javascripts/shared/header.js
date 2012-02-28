
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

  root_url: function() { return "/" + CommonPlace.community.get('slug'); }
  
});
