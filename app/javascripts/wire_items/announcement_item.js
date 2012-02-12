var AnnouncementWireItem = WireItem.extend({
  template: "wire_items/announcement-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    var self = this;
    this.model.bind("destroy", function() { self.remove(); });
    this.in_reply_state = true;
  },

  afterRender: function() {
    this.model.bind("change", this.render, this);
    this.repliesView = {};
    this.reply();
    this.$(".announcement-body").truncate({max_length: 450});
    if (this.thanked()) { this.set_thanked(false, this); }
  },
  
  publishedAt: function() {
    return timeAgoInWords(this.model.get('published_at'));
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  url: function() { return this.model.get('url'); },

  title: function() { return this.model.get('title'); },
  
  author: function() { return this.model.get('author'); },

  first_name: function() { return this.model.get('first_name'); },
  
  body: function() {
    return this.model.get("body");
  },

  numThanks: function() {
    return _.filter(this.model.get("thanks"), function(thank) {
      return thank.thankable_type != "Reply";
    }).length;
  },
  
  peoplePerson: function() {
    return (this.model.get("thanks").length == 1) ? "person" : "people";
  },
  
  events: {
    "click .editlink": "editAnnouncement",
    "mouseenter": "showProfile",
    "mouseenter .announcement": "showProfile",
    "click .announcement > .author": "messageUser",
    "click .thank-link": "thank",
    "click .share-link": "share",
    "click .reply-link": "reply",
    "blur": "removeFocus",
    "click .ts-text": "showThanks"
  },

  editAnnouncement: function(e) {
    if (e) { e.preventDefault(); }
    var formview = new PostFormView({
      model: this.model,
      template: "shared/announcement-edit-form"
    });
    formview.render();
  },

  canEdit: function() {
    return CommonPlace.account.canEditAnnouncement(this.model);
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
    this.options.showProfile(this.model.author());
  },
  
  isFeed: function() { return this.model.get("owner_type") == "Feed"; },
  
  feedUrl: function() { return this.model.get("feed_url"); },
  
  messageUser: function(e) {
    if (!this.isFeed()) {
      if (e) { e.preventDefault(); }
      var user = new User({
        links: {
          self: this.model.get("user_url")
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
    }
  },
  
});
