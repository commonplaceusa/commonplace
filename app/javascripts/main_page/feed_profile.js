var FeedProfile = CommonPlace.View.extend({
  template: "main_page.feed-profile",
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
    CommonPlace.account.subscribeToFeed(this.model, _.bind(function() { this.render(); }, this));
  },

  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromFeed(this.model, _.bind(function() { this.render(); }, this));
  },

  isSubscribed: function() { return CommonPlace.account.isSubscribedToFeed(this.model); },

  isOwner: function() { return CommonPlace.account.isFeedOwner(this.model); },

  url: function() { return this.model.get("url"); }
  
});

