
var InboxRouter = Backbone.Router.extend({
  routes: {
    "/inbox": "show"
  },

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.show();
  },

  show: function() {
    var inboxview = new InboxView({ account: this.account, community: this.community });
    inboxview.render();
    $("#inbox").replaceWith(inboxview.el);
  }
});

