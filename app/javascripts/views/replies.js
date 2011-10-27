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
    "submit form": "sendReply",
    "click .replies-more": "showMoreReplies"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");

    this.collection.each(function(reply, index) {
      var replyview = new ReplyWireItem({ model: reply, account: self.account });

      $ul.append(replyview.render().el);
      if (index < self.hiddenReplyCount() ){
        $(replyview.el).hide();
      }

    });


  },

  pluralizedReplies: function(){
      return (this.hiddenReplyCount() > 1) ? 'replies' : 'reply';
  },

  hiddenReplyCount: function() {
    if (!this._hiddenReplyCount) {
      this._hiddenReplyCount = (this.collection.length > 2) ? this.collection.length - 3 : 0;
    }
    return this._hiddenReplyCount;
  },

  sendReply: function(e) {
    e.preventDefault();
    this.cleanUpPlaceholders();
    this.collection.create({ body: this.$("[name=body]").val()});
  },

  showMoreReplies: function(event){
    event.preventDefault();
    this.$('.reply-item').show();
    this.$('.replies-more').hide();
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});

