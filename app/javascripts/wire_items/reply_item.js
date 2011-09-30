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

    if (this.model.get("author_id") != this.account.id) {
      this.model.user(function(user) {
        var formview = new MessageFormView({
          model: new Message({messagable: user})
        });
        formview.render();
      });
    }
  },

  showProfile: function(e) {
    var user = new User({
      links: { self: this.model.link("author") }
    });
    window.infoBox.showProfile(user);
  }
});
