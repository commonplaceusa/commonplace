var GroupPostResources = CommonPlace.View.extend({
  template: "main_page/group-post-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new GroupPostWireView({ collection: this.community.groupPosts,
                                       account: this.account,
                                       el: this.$(".groupPosts.wire"),
                                       perPage: 15 });
    wire.render();
  }


});
