var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.collection.bind("add", function() { self.render(); });
    this.collection.bind("remove", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "keydown form textarea": "sendReply"
  },

  appendReplies: function() {
    var self = this;
    var elements = this.collection.map(function(reply) {
      var view = new ReplyWireItem({ model: reply, account: self.account });
      view.render();
      return view.el; 
    });
    this.$("ul.reply-list").append(elements);
  },

  pluralizedReplies: function(){
      return (this.hiddenReplyCount() > 1) ? 'replies' : 'reply';
  },

  sendReply: function(e) {
    if (e.which == 13 && !e.shiftKey) {
      e.preventDefault();
      this.cleanUpPlaceholders();
      this.collection.create({ body: this.$("[name=body]").val()});
    }
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});
