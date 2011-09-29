var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.collection.bind("add", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "submit form": "sendReply"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");
    this.collection.each(function(reply) {
      var replyview = new ReplyWireItem({ model: reply, account: self.account });
      $ul.append(replyview.render().el);
    });
  },

  sendReply: function(e) {
    e.preventDefault();
    this.collection.create({ body: this.$("[name=body]").val()});
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});

