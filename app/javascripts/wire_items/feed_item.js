// this is line-for-line the same as group_item. todo: DRY
var FeedWireItem = WireItem.extend({
  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item feed",

  initialize: function() {
    current_account.bind("change", this.render, this);
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

  subscribe: function() { current_account.subscribeToFeed(this.model); },

  unsubscribe: function() { current_account.unsubscribeFromFeed(this.model); },

  isSubscribed: function() { return current_account.isSubscribedToFeed(this.model); }

});


