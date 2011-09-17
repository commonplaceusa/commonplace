var FeedResources = CommonPlace.View.extend({
  template: "main_page/feed-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new FeedWireView({ collection: this.community.feeds,
                                  account: this.account,
                                  el: this.$(".feeds.wire"),
                                  perPage: 15 });
    wire.render();
  }
});
