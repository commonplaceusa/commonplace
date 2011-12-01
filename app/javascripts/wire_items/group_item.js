var GroupWireItem = WireItem.extend({
  // this is line-for-line the same as feed_item. todo: DRY

  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item feed",

  initialize: function() {
    this.account = CommonPlace.account;
    this.account.bind("change", this.render, this);
    this.attr_accessible(['name', 'url', 'avatar_url']);
  },

  events: {
    "mouseenter": "showProfile",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  showProfile: function(e) {
    window.infoBox.showProfile(this.model);
  },

  subscribe: function() { this.options.account.subscribeToGroup(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromGroup(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToGroup(this.model); }

});
