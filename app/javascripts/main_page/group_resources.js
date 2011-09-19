var GroupResources = CommonPlace.View.extend({
  template: "main_page/group-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new GroupWire({ collection: this.community.groups,
                               account: this.account,
                               el: this.$(".groups.wire"),
                               perPage: 15 });
    wire.render();
  }
});
