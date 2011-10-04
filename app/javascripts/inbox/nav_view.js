
var InboxNavView = CommonPlace.View.extend({
  template: "inbox/nav",
  id: "inbox-nav",

  initialize: function(options) {
    this.account = options.account;
  },

  hasFeeds: function() {
    return (this.account.get("feeds").length > 0);
  }
});

