var GroupProfile = CommonPlace.View.extend({
  template: "main_page.group-profile",
  className: "profile",

  events: {
    "click .subscribe": "subscribe",
    "click .unsubscribe": "unsubscribe"
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  about: function() { return this.model.get('about'); },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToGroup(this.model);
    this.render();
  },

  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromGroup(this.model);
    this.render();
  },

  isSubscribed: function() { return CommonPlace.account.isSubscribedToGroup(this.model); },

  url: function() { return this.model.get("url"); }
  
});

