var FeedInfoBox = InfoBox.extend({
  template: "info_boxes/feed-info-box",
  className: "feed",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },
  
  events: { 
    "click button.message": "showMessageForm",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  avatarUrl: function() { return this.model.get("avatar_url"); },

  name: function() { return this.model.get("name"); },

  about: function() { return this.model.get("about"); },

  slug: function() { return this.model.get("slug"); },

  tags: function() { return this.model.get("tags"); },

  website: function() { return this.model.get("website"); },
  
  phone: function() { return this.model.get("phone"); },

  address: function() { return this.model.get("address"); },

  isSubscribed: function() { 
    return this.options.account.isSubscribedToFeed(this.model); 
  },

  subscribe: function() { 
    this.options.account.subscribeToFeed(this.model);
  },

  unsubscribe: function() {
    this.options.account.unsubscribeFromFeed(this.model);
  },

  showMessageForm: function() {
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  }

});