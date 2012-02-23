var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this; 
    this.collection.on("sync", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "focus form textarea": "showButton",
    "blur form textarea": "hideButton",
    "click form .submit-c": "sendReply",
    "click .replies-more": "showMoreReplies"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");

    this.collection.each(function(reply, index) {
      var replyview = new ReplyWireItem({ 
        model: reply, 
        showProfile: self.options.showProfile ,
        thankReply: self.options.thankReply,
        showThanks: self.options.showThanks
      });

      $ul.append(replyview.render().el);
      if (index < self.hiddenReplyCount() ){
        $(replyview.el).hide();
      }

    });
  },

  pluralizedReplies: function(){
      return (this.hiddenReplyCount() > 1) ? 'replies' : 'reply';
  },

  replyCount: function() {
    return this.collection.length;
  },

  hiddenReplyCount: function() {
    if (!this._hiddenReplyCount) {
      this._hiddenReplyCount = (this.collection.length > 2) ? this.collection.length - 3 : 0;
    }
    return this._hiddenReplyCount;
  },

  sendReply: function() {
    if (this.$("form textarea").val()) {
      this.cleanUpPlaceholders();
      this.collection.create(
        { body: this.$("[name=body]").val() },
        {
          success: _.bind(function() { this.collection.trigger("sync"); }, this),
          wait: true
        }
      );
    }
  },

  showMoreReplies: function(event){
    event.preventDefault();
    this.$('.reply-item').show();
    this.$('.replies-more').hide();
  },
  
  showButton: function(e) { this.$(".submit-c").show(); },
  
  hideButton: function(e) { 
    if (!this.$("form textarea").val()) { this.$(".submit-c").hide(); }
  },
  
  accountAvatarUrl: function() { return CommonPlace.account.get('avatar_url'); }
  

    
});
