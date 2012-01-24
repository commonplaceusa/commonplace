var GroupView = CommonPlace.View.extend({
  template: "group_page/group",
  id: "group",

  initialize: function(options) {
    var self = this;
    this.community = options.community;
    this.account = options.account;
    var group = this.model;
    var profile, header, newpost, nav, subresources, list;

    profile = new GroupProfileView({model: group});
    header = new GroupHeaderView({model: group, account: this.account});
    newpost = new NewPostView({model: group, account: this.account});
    subresources = new GroupSubresourcesView({model: group, account: this.account});
    nav = new GroupNavView({
      model: group,
      switchTab: function(tab) { subresources.switchTab(tab); }
    });

    this.subviews = [profile, header, newpost, nav, subresources];

  },
  
  afterRender: function() {
    var self = this;
    _(this.subviews).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  }

});
