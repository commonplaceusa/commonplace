
var FeedWireItem = WireItem.extend({
  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },

  events: {
    "mouseenter": "showProfile",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  name: function() {
    return this.model.get("name");
  },

  getInfoBox: function(callback) {
    callback(new FeedInfoBox({ model: this.model, account: this.options.account }));
  },
  
  getProfile: function(callback) {
    callback(new FeedProfileBox({ model: this.model, account: this.options.account }));
  },

  subscribe: function() { this.options.account.subscribeToFeed(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromFeed(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToFeed(this.model); }

});
