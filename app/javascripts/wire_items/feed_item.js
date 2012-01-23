// this is line-for-line the same as group_item. todo: DRY
var FeedWireItem = WireItem.extend({
  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item feed",

  initialize: function() {
    CommonPlace.account.bind("change", this.render, this);
    this.attr_accessible(['name', 'url', 'avatar_url']);
  },

  events: {
    "mouseenter": "showProfile",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  showProfile: function(callback) {
    CommonPlace.infoBox.showProfile(this.model);
  },

  subscribe: function() { CommonPlace.account.subscribeToFeed(this.model); },

  unsubscribe: function() { CommonPlace.account.unsubscribeFromFeed(this.model); },

  isSubscribed: function() { return CommonPlace.account.isSubscribedToFeed(this.model); }

});


