var FeedProfileBox = Profile.extend({
  template: "main_page.profiles.feed-profile",
  className: "profile",

  events: {
    "click .message": "showMessageForm",
    "click .subscribe": "subscribe",
    "click .unsubscribe": "unsubscribe",
    "click .edit-feed": "showFeedEditForm"
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },
  
  groups: function() { return ""; },

  showMessageForm: function(e) {
    e.preventDefault();
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  },
  
  showFeedEditForm: function(e) {
    e.preventDefault();
    var formView = new FeedEditFormView({
      model: this.model
    });
    formView.render();
  },

  subscribe: function(e) {
    e.preventDefault();
    this.options.account.subscribeToFeed(this.model);
    this.render();
  },

  unsubscribe: function(e) {
    e.preventDefault();
    this.options.account.unsubscribeFromFeed(this.model);
    this.render();
  },

  isSubscribed: function() { return this.options.account.isSubscribedToFeed(this.model); },

  isOwner: function() { return this.options.account.isFeedOwner(this.model); },

  url: function() { return this.model.get("url"); }
  
});

