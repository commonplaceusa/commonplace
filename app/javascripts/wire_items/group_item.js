var GroupWireItem = WireItem.extend({
  // this is line-for-line the same as feed_item. todo: DRY

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

  showProfile: function(e) {
    this.options.showProfile(this.model);
  },

  subscribe: function() { CommonPlace.account.subscribeToGroup(this.model); },

  unsubscribe: function() { CommonPlace.account.unsubscribeFromGroup(this.model); },

  isSubscribed: function() { return CommonPlace.account.isSubscribedToGroup(this.model); }

});
