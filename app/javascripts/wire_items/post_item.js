
var PostWireItem = WireItem.extend({
  template: "wire_items/post-item",
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
    var self = this;
    repliesView.collection.bind("add", function() { self.render(); });
  },

  replyCount: function() {
    var num = this.model.replies().length;
    return (num == 1 ? "1 reply" : num + " replies");
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

  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },

  events: {
    "click .author": "messageUser",
    "click .moreBody": "loadMore",
    "click .editlink": "editPost",
    "mouseenter": "showProfile"
  },

  messageUser: function(e) {
    e && e.preventDefault();
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
    var self = this;
    var user = new User({
      links: { self: this.model.link("author") }
    });
    if (_.any(this.account.get("posts"), function(id) { return self.model.id == id; })) {
      window.infoBox.showAccount(user);
    } else {
      window.infoBox.showUser(user);
    }
  },

  isOwner: function() {
    return this.account.get("id") == this.model.get("user_id");
  },

  editPost: function(e) {
    e.preventDefault();
    var formview = new PostFormView({
      model: this.model,
      template: "shared/post-edit-form"
    });
    formview.render();
  }

});
