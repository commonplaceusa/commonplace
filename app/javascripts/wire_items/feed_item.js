// this is line-for-line the same as group_item. todo: DRY
var FeedWireItem = WireItem.extend({
  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item feed",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
    this.attr_accessible(['name', 'url', 'avatar_url']);
  },

  events: {
    "mouseenter": "showProfile",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  showProfile: function(callback) {
    window.infoBox.showProfile(this.model);
  },

  subscribe: function() { this.options.account.subscribeToFeed(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromFeed(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToFeed(this.model); }

});


