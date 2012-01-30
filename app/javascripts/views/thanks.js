var ThanksView = CommonPlace.View.extend({
  className: "replies",
  template: "shared.thanks",
  
  events: {
    "mouseenter li": "showProfile",
    "click .replies-more": "showAll"
  },
  
  initialize: function(options) {
    this.thanks = this.model.get("thanks");
  },
  
  afterRender: function() {
    var self = this;
    _.each(this.thanks, function(thank, index) {
      if (index < self.hiddenThanksCount()) {
        self.$("li").eq(index).hide();
      }
    });
    this.$(".thankable").text(this.model.get("author"));
  },
  
  users: function() { return this.thanks; },
  
  showProfile: function(e) {
    var user = new User({
      links: { self: $(e.currentTarget).attr("data-thanker-link") }
    });
    this.options.showProfile(user);
  },
  
  showAll: function(e) {
    if (e) { e.preventDefault(); }
    this.$(".replies-more").hide();
    this.$(".reply-item").show();
  },
  
  hiddenThanksCount: function() {
    if (!this._hidden) {
      this._hidden = (this.thanks.length > 2) ? this.thanks.length - 3 : 0;
    }
    return this._hidden;
  }
});
