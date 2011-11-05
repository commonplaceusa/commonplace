var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this;
    this.collection.bind("add", function() { self.render(); });
    this.collection.bind("remove", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "keydown form textarea": "sendReply",
    "focus form textarea": "showHint",
    "blur form textarea": "hideHint"
  },

  appendReplies: function() {
    var self = this;
    var elements = this.collection.map(function(reply) {
      var view = new ReplyWireItem({ model: reply });
      view.render();
      return view.el; 
    });
    this.$("ul.reply-list").append(elements);
  },

  pluralizedReplies: function(){
      return (this.hiddenReplyCount() > 1) ? 'replies' : 'reply';
  },

  sendReply: function(e) {
    this.showHint();
    if (e.which == 13) {
      e.preventDefault();
      if (e.shiftKey) {
        var form = this.$("[name=body]");
        form.val(form.val() + "\n");
      } else {
        this.cleanUpPlaceholders();
        this.collection.create({ body: this.$("[name=body]").val()});
      }
    }
  },
  
  showHint: function(e) { this.$(".enter-hint").show(); },
  
  hideHint: function(e) { this.$(".enter-hint").hide(); },
  
  accountAvatarUrl: function() { return current_account.get('avatar_url'); }
});
