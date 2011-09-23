var ReplyWireItem = WireItem.extend({
  template: "wire_items/reply-item",
  initialize: function(options) {
    this.account = options.account;
    this.model = options.model;
  },

  events: {
    "click .reply-text > .author": "messageUser",
    "mouseenter": "showProfile"
  },

  time: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  author: function() {
    return this.model.get("author");
  },

  authorAvatarUrl: function() {
    return this.model.get("avatar_url");
  },

  body: function() {
    return this.model.get("body");
  },

  messageUser: function(e) {
    if (e) { e.preventDefault(); }

    this.model.user(function(user) {
      var formview = new MessageFormView({
        model: new Message({messagable: user})
      });
      formview.render();
    });
  },

  showProfile: function(callback) {
    var account = this.account;
    this.model.user(function(user) {
      callback(new UserProfileBox({ model: user, account: account }));
    });
  }
});
