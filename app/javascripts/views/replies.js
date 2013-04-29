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
    "click .replies-more": "showMoreReplies",
    "click .register": "showRegistration"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");

    this.collection.each(function(reply, index) {
      var replyview = new CommonPlace.wire_item.ReplyWireItem({ 
        model: reply, 
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

  sendReply: _.throttle(function() {
    if (this.$("form textarea").val()) {
      this.cleanUpPlaceholders();
      this.$("div.submit-c").addClass("waiting");
      this.collection.create(
        {
          body: this.$("[name=body]").val()
        },
        {
          success: _.bind(function() {
            if (typeof _kmq !== "undefined" && _kmq !== null) {
              _kmq.push(['record', 'Sent Reply']);
            }
            this.$("div.submit-c").removeClass("waiting");
            this.collection.trigger("sync");
          }, this),
          wait: true
        }
      );
    }
  }, 1000),

  showMoreReplies: function(event){
    event.preventDefault();
    if (this.isGuest()) {
      this.showRegistration();
      return false;
    } else {
      this.$('.reply-item').show();
      this.$('.replies-more').hide();
    }
  },
  
  showButton: function(e) { this.$(".submit-c").fadeIn(); },
  
  hideButton: function(e) { 
    if (!this.$("form textarea").val()) { this.$(".submit-c").hide(); }
  },
  
  accountAvatarUrl: function() { return CommonPlace.account.get('avatar_url'); }
  

    
});
