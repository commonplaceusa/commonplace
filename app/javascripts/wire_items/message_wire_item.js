
var MessageWireItem = WireItem.extend({
  template: "inbox/message",
  tagName: "li",
  className: "message-item",

  events: {
    "click a.person": "sendMessageToUser"
  },

  afterRender: function() {
    this.repliesView = {};
    this.reply();
    this.model.on("change", this.render, this);
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  date: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  title: function() { return this.model.get("title"); },

  author: function() {
    return this.model.get("author");
  },

  recipient: function() {
    return this.model.get("user");
  },

  message_id: function() {
    return this.model.get("id");
  },

  body: function() { return this.model.get("body"); },

  sendMessageToUser: function(e) {
    e && e.preventDefault();

    var user = new User({
      links: {
        self: this.model.link(this.isSent() ? "user" : "author")
      }
    });
    user.fetch({
      success: function() {
        var formview = new MessageFormView({
          model: new Message({ messagable: user })
        });
        formview.render();
      }
    });
  },

  feedUrl: function() {
    var self = this;
    var feed = new Feed({
      links: {
        self: this.model.link("user")
      }
    });
    feed.fetch({
      success: function() {
        self.$(".messagable.feed").attr("href", feed.get("url"));
      }
    });
  },

  isFeed: function() { return this.model.get("type") == "Feed"; },

  isSent: function() { return this.model.get("author_id") == CommonPlace.account.id; }

});
