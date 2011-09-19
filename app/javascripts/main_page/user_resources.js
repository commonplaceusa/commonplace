var UserResources = CommonPlace.View.extend({
  template: "main_page/user-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new UserWire({ collection: this.community.users,
                              account: this.account,
                              el: this.$(".users.wire"),
                              perPage: 15 });
    wire.render();
  }



});
