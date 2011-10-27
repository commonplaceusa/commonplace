var ReplyWireItem = WireItem.extend({
  tagName: 'li',
  className: 'reply-item',
  template: "wire_items/reply-item",
  initialize: function(options) {
    this.account = options.account;
    this.model = options.model;
  },

  afterRender: function() {
    this.$(".reply-body").truncate({max_length: 450});
  },

  events: {
    "click .reply-text > .author": "messageUser",
    "mouseenter": "showProfile",
    "click .delete-reply": "deleteReply"
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
  },
  
  canEdit: function() {
    return this.account.canEditReply(this.model);
  },
  
  deleteReply: function(e) {
    e.preventDefault();
    var self = this;
    window.f = this.model;
    this.model.destroy();
  }
});
