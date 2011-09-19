var GroupInfoBox = InfoBox.extend({
  template: "info_boxes/group-info-box",
  className: "group",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },
    

  events: {
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  name: function() { return this.model.get("name"); },
  
  about: function() { return this.model.get("about"); },

  avatarUrl: function() { return this.model.get("avatar_url"); },

  isSubscribed: function() {
    return this.options.account.isSubscribedToGroup(this.model);
  },
  
  subscribe: function() { this.options.account.subscribeToGroup(this.model); },
  
  unsubscribe: function() { 
    this.options.account.unsubscribeFromGroup(this.model); 
  }
});