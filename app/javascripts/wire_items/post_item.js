new function($) {
  $.fn.setCursorPosition = function(pos) {
    if ($(this).get(0).setSelectionRange) {
      $(this).get(0).setSelectionRange(pos, pos);
    } else if ($(this).get(0).createTextRange) {
      var range = $(this).get(0).createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
    }
  }
}(jQuery);

var PostWireItem = WireItem.extend({
  template: "wire_items/post-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    var self = this;
    this.model.on("destroy", function() { self.remove(); });
    this.in_reply_state = true;
  },

  afterRender: function() {
    this.model.on("change", this.render, this);
    this.repliesView = {};
    this.reply();
    this.$(".post-body").truncate({max_length: 450});
    this.checkThanked();
    if (this.numThanks() === 0) { this.$(".ts-text").hide(); }
  },

  publishedAt: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  title: function() {
    return this.model.get("title");
  },

  author: function() {
    return this.model.get("author");
  },

  first_name: function() {
    return this.model.get("first_name");
  },

  body: function() {
      return this.model.get("body");
  },

  numThanks: function() {
    return this.directThanks().length;
  },
  
  peoplePerson: function() {
    return (this.model.get("thanks").length == 1) ? "person" : "people";
  },

  events: {
    "click div.group-post > .author": "messageUser",
    "click .editlink": "editPost",
    "mouseenter": "showProfile",
    "mouseenter .post": "showProfile",
    "mouseenter .thank-share": "showProfile",
    "click .thank-link": "thank",
    "click .share-link": "share",
    "click .reply-link": "reply",
    "blur": "removeFocus",
    "click .ts-text": "showThanks"
  },

  messageUser: function(e) {
    if (e) { e.preventDefault(); }
    var user = new User({
      links: {
        self: this.model.get("links").author
      }
    });
    user.fetch({
      success: function() {
        var formview = new MessageFormView({
          model: new Message({messagable: user})
        });
        formview.render();
      }
    });
  },

  isMore: function() {
    return !this.allwords;
  },

  loadMore: function(e) {
    e.preventDefault();
    this.allwords = true;
    this.render();
  },

  showProfile: function(e) {
    var user = new User({
      links: { self: this.model.link("author") }
    });
    this.options.showProfile(user);
  },

  canEdit: function() { return CommonPlace.account.canEditPost(this.model); },

  editPost: function(e) {
    e.preventDefault();
    var formview = new PostFormView({
      model: this.model,
      template: "shared/post-edit-form"
    });
    formview.render();
  },

  group: function() { return false; },

});
