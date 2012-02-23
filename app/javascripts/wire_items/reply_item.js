var ReplyWireItem = WireItem.extend({
  tagName: 'li',
  className: 'reply-item',
  template: "wire_items/reply-item",
  initialize: function(options) {
  },

  afterRender: function() {
    this.$(".reply-body").truncate({max_length: 450});
    this.$(".markdown p").last().append(this.$(".controls"));
  },

  events: {
    "click .reply-text > .author": "messageUser",
    "mouseenter": "showProfile",
    "click .delete-reply": "deleteReply",
    "click .thank-reply": "thankReply",
    "click .thanks_count": "showThanks"
  },

  time: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  author: function() {
    return this.model.get("author");
  },
  
  first_name: function() {
    return this.author().split(" ")[0];
  },

  authorAvatarUrl: function() {
    return this.model.get("avatar_url");
  },

  body: function() {
    return this.model.get("body");
  },

  messageUser: function(e) {
    if (e) { e.preventDefault(); }

    if (this.model.get("author_id") != CommonPlace.account.id) {
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
    this.options.showProfile(user);
  },
  
  canEdit: function() {
    return CommonPlace.account.canEditReply(this.model);
  },
  
  deleteReply: function(e) {
    e.preventDefault();
    var self = this;
    this.model.destroy();
  },
  
  numThanks: function() { return this.model.get("thanks").length; },
  
  hasThanks: function() { return this.numThanks() > 0; },
  
  peoplePerson: function() { return (this.numThanks() == 1) ? "person" : "people"; },
  
  hasThanked: function() {
    return _.any(this.model.get("thanks"), function(thank) {
      return thank.thanker == CommonPlace.account.get("name");
    });
  },
  
  canThank: function() {
    return this.model.get("author_id") != CommonPlace.account.id;
  },
  
  thankReply: function(e) {
    if (e) { e.preventDefault(); }
    $.post("/api" + this.model.link("thank"), this.options.thankReply);
  },
  
  showThanks: function(e) {
    if (e) { e.preventDefault(); }
    this.options.showThanks();
  }
});
