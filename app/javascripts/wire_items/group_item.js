var GroupWireItem = WireItem.extend({
  // this is line-for-line the same as feed_item. todo: DRY

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

  showProfile: function(e) {
    window.infoBox.showProfile(this.model);
  },

  subscribe: function() { current_account.subscribeToGroup(this.model); },

  unsubscribe: function() { current_account.unsubscribeFromGroup(this.model); },

  isSubscribed: function() { return current_account.isSubscribedToGroup(this.model); }

});
