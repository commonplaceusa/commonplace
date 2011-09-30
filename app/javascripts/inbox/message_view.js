
var MessageWireItem = WireItem.extend({
  template: "inbox/message",
  tagName: "li",
  className: "message-item",

  initialize: function(options) {
    this.account = options.account;
    this.model = options.model;
    this.community = options.community;
  },

  afterRender: function() {
    var repliesView = new RepliesView({
      collection: this.model.replies(),
      el: this.$(".replies"),
      account: this.account
    });
    repliesView.render();
    this.model.bind("change", this.render, this);
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  date: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  title: function() { return this.model.get("title"); },

  author: function() { return this.model.get("author"); },

  body: function() { return this.model.get("body"); }

});
