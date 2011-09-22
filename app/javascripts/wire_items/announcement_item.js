var AnnouncementWireItem = WireItem.extend({
  template: "wire_items/announcement-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = options.account;
    this.shortbody = this.model.get("body").match(/\b([\w]+[\W]+){60}/);
    this.allwords = (this.shortbody == null);
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
  },
  
  publishedAt: function() {
    return timeAgoInWords(this.model.get('published_at'));
  },

  replyCount: function() {
    var num = this.model.get('replies').length;
    return (num == 1 ? "1 reply" : num + " replies");
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  url: function() { return this.model.get('url'); },

  title: function() { return this.model.get('title'); },
  
  author: function() { return this.model.get('author'); },
  
  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },
  
  events: {
    "click .editlink": "editAnnouncement",
    "click .moreBody": "loadMore",
    "mouseenter": "showProfile"
  },

  editAnnouncement: function(e) {
    e && e.preventDefault();
    var formview = new AnnouncementFormView({
      model: this.model,
      template: "shared/announcement-edit-form"
    });
    formview.render();
  },

  isOwner: function() {
    return (this.account.get("id") == this.model.get("user_id"));
  },

  isMore: function() {
    return !this.allwords;
  },

  loadMore: function(e) {
    e.preventDefault();
    this.allwords = true;
    this.render();
  },

  getProfile: function(callback) {
    var self = this;
    this.model.author(function(author) {
      if (self.model.get("owner_type") == "Feed") {
        callback(new FeedProfileBox({ model: author, account: self.account }));
      } else {
        callback(new UserProfileBox({ model: author, account: self.account }));
      }
    });
  }
    
});
