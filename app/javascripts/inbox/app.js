
var InboxRouter = Backbone.Router.extend({
  routes: {
    "": "showReceived",
    "received": "showReceived",
    "sent": "showSent"
  },

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  show: function(type) {
    var inboxnav = new InboxNavView({ account: this.account, community: this.community });
    var inboxview = new InboxView({ account: this.account, community: this.community, type: type });
    inboxnav.render();
    inboxview.render();
    $("#nav").replaceWith(inboxnav.el);
    $("#inbox").replaceWith(inboxview.el);
    $(".nav-tab").removeClass("current");
    $("." + type).addClass("current");
  },

  showReceived: function() { this.show("received"); },

  showSent: function() { this.show("sent"); }
});

