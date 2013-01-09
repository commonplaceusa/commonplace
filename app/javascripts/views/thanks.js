var ThanksListView = CommonPlace.View.extend({
  className: "thanks",
  template: "shared.thanks",

  events: {
    "click .replies-more": "showAll"
  },

  initialize: function(options) {
    this.thanks = this.model.get("thanks");
  },

  afterRender: function() {
    _.each(this.thanks, _.bind(function(thank, index) {
      var item = new this.ThanksItemView({
        model: thank
      });
      item.render();
      this.$("ul").append(item.el);
      if (index < this.hiddenThanksCount()) {
        $(item.el).hide();
      }
    }, this));
  },

  showAll: function(e) {
    if (e) { e.preventDefault(); }
    this.$(".replies-more").hide();
    this.$("li").show();
  },

  hiddenThanksCount: function() {
    if (!this._hidden) {
      this._hidden = (this.thanks.length > 2) ? this.thanks.length - 3 : 0;
    }
    return this._hidden;
  },

  ThanksItemView: CommonPlace.View.extend({
    template: "shared.thanks-item",
    tagName: "li",
    className: "reply-item",

    avatar_url: function() { return this.model.avatar_url; },
    thanker: function() { return this.model.thanker; },
    thankable_author: function() { return this.model.thankable_author; },

    isReply: function() { return this.model.thankable_type == "Reply"; }
  })
});
