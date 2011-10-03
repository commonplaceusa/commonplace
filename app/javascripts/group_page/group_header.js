var GroupHeaderView = CommonPlace.View.extend({
  template: "group_page/header",
  id: "group-header",
  
  initialize: function(options) { this.account = options.account; },

  name: function() {
    return this.model.get("name");
  },

  isSubscribed: function() {
    return this.account.isSubscribedToGroup(this.model);
  },

  events: {
    "click a.subscribe": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  subscribe: function(e) {
    var self = this;
    e.preventDefault();
    this.account.subscribeToGroup(this.model, function() { self.render(); });
  },

  unsubscribe: function(e) {
    var self = this;
    e.preventDefault();
    this.account.unsubscribeFromGroup(this.model, function() { self.render(); });
  }
});
