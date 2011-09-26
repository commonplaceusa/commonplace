var GroupProfileBox = Profile.extend({
  template: "main_page/profiles/group-profile",
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
    this.options.account.subscribeToGroup(this.model);
    this.render();
  },

  unsubscribe: function(e) {
    e.preventDefault();
    this.options.account.unsubscribeFromGroup(this.model);
    this.render();
  },

  isSubscribed: function() { return this.options.account.isSubscribedToGroup(this.model); }
  
});
