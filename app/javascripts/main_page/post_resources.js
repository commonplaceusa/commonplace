var PostResources = CommonPlace.View.extend({
  template: "main_page/post-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new PostWireView({ collection: this.community.posts,
                                  account: this.account,
                                  el: this.$(".posts.wire"),
                                  perPage: 15 });
    wire.render();
  }
});
