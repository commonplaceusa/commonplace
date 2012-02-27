var WireItem = CommonPlace.View.extend({

  checkThanked: function() {
    if (this.thanked()) {
      this.$(".thank-link").html("Thanked!");
      this.$(".thank-link").addClass("thanked-post");
    }
  },
  
  thanked: function() {
    var thanks = _.map(this.directThanks(), function(thank) { return thank.thanker; });
    return _.include(thanks, CommonPlace.account.get("name"));
  },
  
  directThanks: function() {
    return _.filter(this.model.get("thanks"), function(t) {
      return t.thankable_type != "Reply";
    });
  },

  thank: function() {
    this.$(".thank-share .current").removeClass("current");
    if (this.thanked()) {
      return this.showThanks();
    }
    $.post("/api" + this.model.link("thank"), _.bind(function(response) {
      this.model.set(response);
      this.render();
      this.showThanks();
    }, this));
  },
  
  showThanks: function(e) {
    if (e) { e.preventDefault(); }
    if (!_.isEmpty(this.model.get("thanks"))) {
      this.removeFocus();
      this.$(".thank-link").addClass("current");
      this.$(".replies-area").empty();
      var thanksView = new ThanksListView({
        model: this.model,
        showProfile: this.options.showProfile
      });
      thanksView.render();
      this.$(".replies-area").append(thanksView.el);
      this.state = "thanks";
    }
  },

  share: function(e) {
    if (e) { e.preventDefault(); }
    this.state = "share";
    this.removeFocus();
    this.$(".replies-area").empty();
    this.$(".share-link").addClass("current");
    var shareView = new ShareView({ model: this.model,
                                    account: CommonPlace.account
                                  });
     shareView.render();
     this.$(".replies-area").append(shareView.el);
   },

  reply: function(e) {
    if (e) { e.preventDefault(); }
    var isFirst = _.isEmpty(this.repliesView);
    if (this.state != "reply" || isFirst) {
      this.removeFocus();
      this.$(".reply-link").addClass("current");
      this.$(".replies-area").empty();
      this.repliesView = new RepliesView({
        collection: this.model.replies(),
        showProfile: this.options.showProfile,
        thankReply: _.bind(function(response) {
          this.model.set(response);
        }, this),
        showThanks: _.bind(function() {
          this.showThanks();
        }, this)
      });
      this.repliesView.collection.on("change", _.bind(function() { this.render(); }, this));
      this.repliesView.render();
      this.$(".replies-area").append(this.repliesView.el);
    }
    if (!isFirst) {
      this.$(".reply-text-entry").focus();
      this.state = "reply";
    }
  },
  
  removeFocus: function() {
    this.$(".thank-share .current").removeClass("current");
  }
});
